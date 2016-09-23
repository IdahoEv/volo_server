defmodule Volo.Game.ProcessNamesTest do
  use ExSpec, async: true

  # doctest Volo.Game.ProcessNames

  alias Volo.Game.ProcessNames
  describe "name functions" do
    it "makes the correct names" do
      assert :"game_1234" == ProcessNames.game("1234")
      assert :"world_1234" == ProcessNames.world("1234")
      assert :"updater_1234" == ProcessNames.updater("1234")
      assert :"scoreboard_1234" == ProcessNames.scoreboard("1234")
      assert :"player_sup_1234" == ProcessNames.player_supervisor("1234")
      assert :"game_sup_1234" == ProcessNames.game_supervisor("1234")
    end
  end
end
