defmodule GameTest do
  use ExSpec, async: true
  
  alias Volo.Game.RegistryUtils

  alias Volo.Game
  alias Volo.Game.PlayerSupervisor
  alias Volo.Game.Player
  alias Volo.Game.PlayerList
  
  doctest Volo.Game

  setup _ do
    game_id = "1"
    {:ok, supervisor} = PlayerSupervisor.start_link(["1"])

    on_exit fn -> Process.exit(supervisor, :normal) end
         
    [ state: %Game{ game_id: "1" },
      game_id: game_id
    ]
  end

  describe "connecting a player" do
    context "with no private_id specified" do

      it "creates a new player and returns the right stuff", data do
        state = data[:state]

        return = Game.handle_call({:connect_player, 'name', nil}, self(), state)

        # player Map is returned, contains correct info
        assert { :reply, { :ok, player }, updated_state } = return
        assert %Player{}                                  = player

        # player list contains this player and is findable by private id
        assert Enum.count(updated_state.players) == 1
        assert PlayerList.retrieve(
          updated_state.players, {:private_id, player.private_id}
          ) == {  player.id, player.private_id, 'name' }

        # side effects - creates a player process
        assert Process.alive?(RegistryUtils.get_pid(data[:game_id], :player, player.id))
      end

      # @tag :focus
      it "if the name is taken it returns an error", data do

        # First player addition called 'name' is okay
        return_1 = Game.handle_call({:connect_player, 'name', nil}, self(), data[:state])
        assert { :reply, { :ok, _player }, state_1 } = return_1
        
        # Second player addition called 'name' is not okay, return includes
        # { :error, :name_taken }
        return_2 = Game.handle_call({:connect_player, 'name', nil}, self(), state_1)
        assert { :reply, { :error, :name_taken }, _state_2 }  = return_2
      end
    end

    context "with a private_id that matches an existing player" do
      # @tag :focus
      it "if the name matches, it connects this websocket to that player", data do
        # connect a player
        return_1 = Game.handle_call({:connect_player, 'name', nil}, self(), data[:state])
        assert { :reply, { :ok, player }, state_1 } = return_1

        # reconnect the same player by specifying private_id
        return_2 = Game.handle_call(
          { :connect_player, 'name', player.private_id }, 
            'new_websocket_pid', state_1
          )
        assert { :reply, { :ok, player_2 }, _state_2 } = return_2
        # player state should have the new websocket pid 
        assert player_2.websocket_pid == 'new_websocket_pid'
        assert Player.get_state(
            RegistryUtils.via_tuple(data[:game_id], :player, player_2.id)
          ).websocket_pid == 'new_websocket_pid'             
      end
      
      it "if the name doesn't match, it returns an error", data do
        # connect a player
        return_1 = Game.handle_call({:connect_player, 'name', nil}, self(), data[:state])
        assert { :reply, { :ok, player }, state_1 } = return_1

        # reconnect the same player by specifying private_id, but with
        # a mismatched name 
        return_2 = Game.handle_call(
          { :connect_player, 'wrong_name', player.private_id }, 
            'new_websocket_pid', state_1
          )
        assert { :reply, { :error, :player_not_found }, ^state_1 } = return_2      
      end
    end

    context "with a private_id that doesn't exist in this game" do
      it "rejects with :player_not_found", data do

        # connect a player
        return_1 = Game.handle_call({:connect_player, 'name', nil}, self(), data[:state])
        assert { :reply, { :ok, _player }, state_1 } = return_1

        # reconnect the same player by specifying private_id, but with
        # a mismatched name 
        return_2 = Game.handle_call(
          { :connect_player, 'name', 'not_a_valid_private_id' }, 
            'new_websocket_pid', state_1
          )
        assert { :reply, { :error, :player_not_found }, ^state_1 } = return_2              
      end
    end
  end
end
