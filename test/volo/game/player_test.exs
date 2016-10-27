defmodule PlayerTest do
  use ExSpec, async: true
  
  alias Volo.Game.Player  
  doctest Volo.Game.Player
  
  describe "start_link/2" do
    it "starts a process and generates the correct state" do
      assert {:ok, pid} = Player.start_link("john", "game_1", "websocket_pid")
      
      state = Player.get_state(pid) 
      assert state.name           == "john"
      assert state.game_id        == "game_1"
      assert state.websocket_pid  == "websocket_pid"
      assert state.id             != nil
      assert state.private_id     != nil
    end
  end
end