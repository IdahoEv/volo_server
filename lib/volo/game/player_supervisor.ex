defmodule Volo.Game.PlayerSupervisor do
  use Supervisor
  import Volo.Game.RegistryUtils

  # API
  def start_link([game_id]) do
    Supervisor.start_link(__MODULE__, [game_id],
      name: via_tuple(game_id, :player_supervisor))
  end

  # GenServer Callbacks
  def init([game_id]) do
    label_for_development(__MODULE__, game_id)

    children = [ worker(Volo.Game.Player, [game_id], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
