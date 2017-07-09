defmodule Volo.Web.WebsocketHandler do
  import Apex.AwesomeDef
  @behaviour :cowboy_websocket_handler

  @heartbeat_interval 500
  
  alias Volo.Game
  alias Volo.Game.Player
  alias Volo.Web.Heartbeat

  defstruct player_id: nil,
            private_id: nil,
            game_id: nil,
            heartbeat_history: []

  def init(req, [game_id]) do
    
    # NOTE: For now, a single game is created and its PID (or rather, via tuple)
    # is passed in to the websocket handler's state.  TO support multiple games,
    # a game lobby will identify availabke games to the client, which will request
    # connection to them by looking up that game's process in the :gproc registry
    # game_id |> Trace.i("Websocket init, game id is:")
    {:cowboy_websocket, req, %__MODULE__{ game_id: game_id }}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle({:text, msg}, req, state) do
    [ wsocket: self(), message: msg, state: state] 
    # |> Trace.i("Incoming frame on websocket")
    
    data = Poison.Parser.parse!(msg, as: %{})
      # |> Trace.i ("Websocket data:")
    handle_message(data, req, state)
      # |> Trace.i ("websocket_handle returning: ")
    # { :ok, req, state }
  end
  
  def websocket_handle(frame, req, state) do
    [ frame: frame, req: req, state: state]
    |> Trace.ap("Unhandled frame received by websocket handler:")
  end

  @doc """
  Handle connection messages 
  """
  def handle_message(%{ "connect" => data }, req, state) do
    case Game.connect_player(state.game_id, data) 
      # |> Trace.i("Game response to connection attempt") 
      do
        #TODO: Update state with player ID and private ID?
      { :ok, player } -> successful_connection(player)
      { :error, reason } -> failed_connection(reason)
    end
    # |> Trace.i "Websocket message response"
    |> reply(req, state)
  end

  @doc """
  Handle Heartbeat replies, compute RTT
  """
  def handle_message(%{ "heartbeat_reply" => data }, req, state) do                        
    # [ data: data, req: req, state: state]
    history = state.heartbeat_history
      |> Heartbeat.update_list_with_reply(data, Volo.Util.Time.now())
      # |> Trace.ap("heartbeat history")
      
    { :ok, req, %__MODULE__{ state | heartbeat_history: history } }
  end
  
  def handle_message(data, req, state) do
    %{ "heartbeat_reply" => content } = data
    data |> Trace.i("Unhandled message received by websocket handler:")
    { :ok, req, state }
  end
  
  
  @doc """
  # Loop to send periodic heartbeat
  """
  def websocket_info(:send_heartbeat, req, state) do
    Process.send_after(self(), :send_heartbeat, @heartbeat_interval)
    heartbeat = %Heartbeat{ 
      id: Volo.Util.ID.short(),
      sent: Volo.Util.Time.now()
    }
    message = heartbeat_message(heartbeat) 
    history = state.heartbeat_history
      |> Heartbeat.append_to_list(heartbeat)
      
    { :reply, { :text, message }, req, 
      %__MODULE__{ state | heartbeat_history: history }
    }
  end
  
  def heartbeat_message(heartbeat) do
    { :ok, message } = Poison.encode(%{
      heartbeat: %{
        id: heartbeat.id,
        sent: heartbeat.sent
      }
    })
    message
  end
  
  def initiate_heartbeat do
    IO.puts("Initiating heartbeat") 
    Process.send_after(self(), :send_heartbeat, @heartbeat_interval)
  end

  defp successful_connection(player) do
    { :ok, message_string } = Poison.encode %{ connected: %{
      private_id: player.private_id,
      game_id: player.game_id,
      player_name: player.name
    }}
    initiate_heartbeat()
    message_string
  end

  defp failed_connection(reason) do
    { :ok, message_string } = Poison.encode %{ connection_failed: reason }
    message_string
  end

  defp reply(message, req, state) do
    Trace.ap message, "WS Handler reply message"
    { :reply, { :text, message}, req, state } # |> Trace.ap "WS Handler reply retval"
  end
end
