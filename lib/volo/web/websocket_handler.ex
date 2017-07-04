defmodule Volo.Web.WebsocketHandler do
  import Apex.AwesomeDef
  @behaviour :cowboy_websocket_handler

  alias Volo.Game
  alias Volo.Game.Player

  defstruct player_id: nil,
            private_id: nil,
            game_id: nil

  def init(req, [game_id]) do
    
    # NOTE: For now, a single game is created and its PID (or rather, via tuple)
    # is passed in to the websocket handler's state.  TO support multiple games,
    # a game lobby will identify availabke games to the client, which will request
    # connection to them by looking up that game's process in the :gproc registry
    game_id #|> Trace.i("Websocket init, game id is:")
    {:cowboy_websocket, req, [ game_id: game_id ]}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle({:text, msg}, req, state) do
    [ wsocket: self, message: msg, state: state] 
    # |> Trace.i("Incoming frame on websocket")
    
    data = Poison.Parser.parse!(msg, as: %{})
      # |> Trace.i ("Websocket data:")
    handle_message(data, req, state)
      # |> Trace.i ("websocket_handle returning: ")
    # { :ok, req, state }
  end
  
  def websocket_handle(frame, req, state) do
    [ frame: frame, req: req, state: state]
    # |> Trace.ap ("Unhandled frame received by websocket handler:")
  end

  def handle_message(%{ "connect" => data},req,state) do
    [data: data, req: req, state: state] |> Trace.i("Handle Message")
    case Game.connect_player(state[:game_id], data) do
      # |> Trace.i("Game response to connection attempt") do
      { :ok, player } -> successful_connection(player)
      { :error, reason } -> failed_connection(reason)
    end 
    #  |> Trace.i("Result of connection attempt")  
    { :reply, { :text, "1" }, req, state }
  end
  # def handle_message(%{ "connect" => data }, req, state) do
  #   [ data: data, req: req, state: state]
  #   |> Trace.i "handle_message called with"
  #   case Game.connect_player(state[:game_id], data) 
  #     |> Trace.i("Game response to connection attempt") do
  #     { :ok, player } -> successful_connection(player)
  #     { :error, reason } -> failed_connection(reason)
  #   end
  #   |> reply(req, state)
  # end
  # 
  # def handle_message(data, req, state) do
  #   data
  #      |> Trace.i "Unhandled message received by websocket handler:"
  #   { :ok, state }
  # end

  defp successful_connection(player) do
    Poison.encode %{ connected: %{
      private_id: player.private_id,
      game_id: player.game_id
    }}
  end

  defp failed_connection(reason) do
    Poison.encode %{ connection_failed: reason }
  end

  defp reply(message, req, state) do
    { :reply, { :text, message}, req, state}
  end
end
