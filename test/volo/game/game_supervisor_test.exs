defmodule GameSupervisorTest do
  use ExSpec, async: true

  doctest Volo.Game.GameSupervisor

  describe "Starting a new game" do
    it "should build the initial supervision tree" do
      { sup_pid, game_number } = Volo.Game.GameSupervisor.new_game
      assert Process.alive?(sup_pid)
      # assert Process.whereis(:"game_#{game_number}")
      # assert Process.alive?("world_#{game_number}")
      # assert Process.alive?("updater_#{game_number}")
      # assert Process.alive?("player_sup_#{game_number}")
    end
  end
end
