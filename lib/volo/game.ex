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
    GenServer.start_link(__MODULE__,
      [game_id],
      opts
    )
  end

  @doc """
  Called by websocket to connect a player to this game.  Returns one
  of:
  { :ok, player_pid, player_state }
  { :error, reason }
  """
  def connect_player(data) do
    GenServer.call(:connect_player, data)
  end

  def disconnect_player, do: nil
  def get_players, do: nil

  # Callbacks
  def init(game_id) do
    label_for_development(__MODULE__, game_id)
    {:ok, %__MODULE__{ game_id: game_id }}
  end

  @doc """
  Handle request to connect a player.  Reply is one of:
  { :ok, player_pid, player_state }
  { :error, reason }
  """
  def handle_call( {:connect_player, name, nil}, websocket_pid, state) do
    {:ok, player_pid} = via_tuple(state.game_id, :player_supervisor)
    |> PlayerSupervisor.add_player(name, state.game_id, websocket_pid)

    player = Player.get_state(player_pid)
    player_list = PlayerList.store(state.players, player.id, player.private_id, name)

    # needs private_id, game_id, and name
    { :reply,
      {:ok, player_pid, player},
      %{ state | players: player_list }
    }
  end

end
