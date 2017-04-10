defmodule Volo.Game.PlayerSupervisor do
  use Supervisor
  import Volo.Game.RegistryUtils
  import Apex.AwesomeDef

  # API
  def start_link([game_id], opts \\ []) do
    Supervisor.start_link(__MODULE__, [game_id],
      Keyword.merge(opts, name: via_tuple(game_id, :player_supervisor)))
  end

  def add_player(supervisor_pid, name, game_id, websocket_pid) do
    Supervisor.start_child(supervisor_pid, [name, game_id, websocket_pid])
  end

  # Supervisor Callbacks
  def init([game_id]) do
    label_for_development(__MODULE__, game_id)

    children = [ worker(Volo.Game.Player, [], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
