defmodule Volo.Game do
  use GenServer
  import Volo.Game.RegistryUtils

  alias Volo.Game.Player
  alias Volo.Game.PlayerList
  alias Volo.Game.PlayerSupervisor

  defstruct players:    Volo.Game.PlayerList.new,
            start_time: Volo.Util.Time.now,
            game_id: nil

  # API
  def start_link([game_id], opts \\ []) do
    Trace.i(game_id, "game start link")
    GenServer.start_link(__MODULE__,
      [game_id],
      Keyword.merge(opts, name: via_tuple(game_id, :game))
    )
  end

  @doc """
  Called by websocket to connect a player to this game.  Returns one
  of:
  { :ok, player_pid, player_state }
  { :error, reason }
  """
  def connect_player(game_id, data) do
    [ gid: game_id, data: data] |> Trace.i("connect_player API called")
    GenServer.call(via_tuple(game_id, :game), 
      {:connect_player, "foo", data["private_id"]})
      |> Trace.i("Via tuple for connect_player")
  end

  def disconnect_player, do: nil
  def get_players, do: nil

  # Callbacks
  def init([game_id]) do
    label_for_development(__MODULE__, game_id)
    {:ok, %__MODULE__{ game_id: game_id }}
  end

  @doc """
  Handle request to connect a player.  Third argument (private id) should be
  nil if the player is new to this game, and a player private id if the
  player is in this game but was disconnected.  
  
  Reply is one of:
  { :ok,    player_state }
  { :error, reason }
  """
  def handle_call( {:connect_player, name, nil}, websocket_pid, state) do
    [ name: name, ws_pid: websocket_pid, state: state ] |> Trace.i("connect player no private id")
    PlayerList.retrieve(state.players, { :name, name })
    #  |> Trace.ap "Find by name >#{name}<"

    # check whether this name is in use
    if PlayerList.retrieve(state.players, { :name, name }) do
      { :reply, { :error, :name_taken }, state }
    else
      add_player(name, websocket_pid, state)
    end
  end

  def handle_call( {:connect_player, name, private_id}, websocket_pid, state) do
    [ name: name, ws_pid: websocket_pid, state: state ] |> Trace.i("connect player with private id")
    case PlayerList.retrieve(state.players, { :private_id, private_id }) do
      # player is found and name matches
      { player_id, private_id, ^name } -> reconnect_player(player_id, websocket_pid, state)
      
      # anything else happens
      _ -> { :reply, { :error, :player_not_found }, state }
    end    
  end

  defp reconnect_player(player_id, websocket_pid, state) do
    player_pid = via_tuple(state.game_id, :player, player_id )    
    player = Player.update_websocket(player_pid, websocket_pid) 
    { :reply, { :ok, player }, state }   
  end

  defp add_player(name, websocket_pid, state) do
    sup_pid = via_tuple(state.game_id, :player_supervisor)
    if name == nil do
      name = available_guest_name(state)
    end
    {:ok, player_pid} = PlayerSupervisor.add_player(sup_pid, name, state.game_id, websocket_pid)

    player = Player.get_state(player_pid)
    player_list = PlayerList.store(state.players, player.id, player.private_id, name)

    # needs private_id, game_id, and name
    { :reply,
      { :ok, player },
      %{ state | players: player_list }
    }
  end
  
  defp available_guest_name(state) do
    available_guest_name(state, 1)
  end
  
  defp available_guest_name(state, nn) do
    name = "Guest #{nn}"
    if PlayerList.retrieve(state.players, { :name, name }) do
      available_guest_name(state, nn + 1)
    else
      name
    end
  end
  

end
