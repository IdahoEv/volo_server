defmodule Volo.Game.PlayerSupervisor do
  use Supervisor
  import Volo.Game.RegistryUtils

  # API
  def start_link(args) do
    IO.puts "Starting #{__MODULE__} with "
    IO.inspect args
    IO.puts "-----------"
    Supervisor.start_link(__MODULE__, args, name: via_tuple(args, :player_supervisor))
  end

  # GenServer Callbacks
  def init(args) do
    children = [ worker(Volo.Game.Player, args, restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
