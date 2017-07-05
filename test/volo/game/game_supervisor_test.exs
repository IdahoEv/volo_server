defmodule GameSupervisorTest do
  use ExSpec, async: true
  
  alias Volo.Game.RegistryUtils

  doctest Volo.Game.GameSupervisor

  describe "Starting a new game" do
    it "should build the initial supervision tree" do
      { sup_pid, _game_number } = Volo.Game.GameSupervisor.new_game
      assert Process.alive?(sup_pid)
      assert %{active: 5, specs: 5, supervisors: 1, workers: 4}
        == Supervisor.count_children(sup_pid)

      # find the modules associated with the children of the supervisor
      modules = Supervisor.which_children(sup_pid)
      |> Enum.map(fn({mod, _, _, _}) -> mod end)

      # assert that they are exactly the ones in this list
      assert [Volo.Game,
        Volo.Game.Scoreboard,
        Volo.Game.World,
        Volo.Game.Updater,
        Volo.Game.PlayerSupervisor
      ] -- modules == []
    end

    it "should assert that they are correctly registered with :gproc" do
      { _sup_pid, game_id } = Volo.Game.GameSupervisor.new_game
      assert :gproc.lookup_pid(RegistryUtils.gproc_regkey(game_id, :game))
      assert :gproc.lookup_pid(RegistryUtils.gproc_regkey(game_id, :world)) 
      assert :gproc.lookup_pid(RegistryUtils.gproc_regkey(game_id, :scoreboard))
      assert :gproc.lookup_pid(RegistryUtils.gproc_regkey(game_id, :updater))
      assert :gproc.lookup_pid(RegistryUtils.gproc_regkey(game_id, :player_supervisor))
      assert :gproc.lookup_pid(RegistryUtils.gproc_regkey(game_id, :game_supervisor))
    end
    
  end
end
