defmodule Volo.Game.PlayerSupervisor do
  use Supervisor
  import Volo.Game.RegistryUtils

  # API
  def start_link([game_number]) do
    Supervisor.start_link(__MODULE__, [game_number],
      name: via_tuple(game_number, :player_supervisor))
  end

  # GenServer Callbacks
  def init([game_number]) do
    children = [ worker(Volo.Game.Player, [game_number], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
