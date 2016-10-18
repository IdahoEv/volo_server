defmodule GameTest do
  use ExSpec, async: true

  alias Volo.Game
  alias Volo.Game.PlayerSupervisor
  alias Volo.Game.Player
  alias Volo.Game.PlayerList
  doctest Volo.Game

  describe "connecting a player" do
    context "with no private_id specified" do

      @tag :focus
      it "creates a new player and returns the right stuff" do
        state = %Game{ game_id: "1" }
        player_supervisor = PlayerSupervisor.start_link([state.game_id])

        return = Game.handle_call({:connect_player, 'name', nil}, self, state)

        # player Map is returned, contains correct info
        assert { :reply, ok_tuple, updated_state }  = return
        assert { :ok, player_pid, player }          = ok_tuple
        assert %Player{}                            = player

        IO.inspect player
        # TODO: move these to unit tests for Player.start_link/2
        assert private_id                           = player.private_id
        assert 'name'                               = player.name
        assert "1"                                  = player.game_id
        assert self                                 == player.websocket_pid


        assert Enum.count(updated_state.players) == 1
        assert PlayerList.retrieve(
          updated_state.players, {:private_id, private_id}) == {
            player.id, private_id, 'name'
          }

        # side effects - creates a player process
        assert Process.alive?(player_pid)
      end
      it "if the name is taken it returns an error" do
        state = %Game{ game_id: "1" }
        player_supervisor = PlayerSupervisor.start_link([state.game_id])

        return_1 = Game.handle_call({:connect_player, 'name', nil}, self, state)
        return_2 = Game.handle_call({:connect_player, 'name', nil}, self, state)

        assert { :reply, err_tuple, updated_state }  = return_2
        assert { :error, :name_taken }               = err_tuple
      end
    end

    context "with a private_id that matches an existing player" do
      it "if the name matches, it connects this websocket to that player"
      it "if the name doesn't matches, it returns an error"
    end

    context "with a private_id that doesn't exist in this game" do
      it "creates a new player and returns private_id and game_id"
    end
  end
end
