defmodule PlayerListTest do
  use ExSpec, async: true

  alias Volo.Game.PlayerList
  doctest Volo.Game.PlayerList

  describe "looking up players" do
    setup context do
      list = PlayerList.new
      |> PlayerList.store("1234", "priv_1234", "awesome")
      |> PlayerList.store("0000", "priv_0000", "Jane")
      [ list: list ]
    end

    @tag :focus
    it "finds players by id", context do
      # Trace.ap context, "Context"
      assert PlayerList.retrieve(context[:list], "1234") == { "1234", "priv_1234", "awesome"}
      assert PlayerList.retrieve(context[:list], "0000") == { "0000", "priv_0000", "Jane"}
    end

    it "finds players by private_id", context do
      assert PlayerList.retrieve(context[:list], {:private_id, "priv_1234"}) == { "1234", "priv_1234", "awesome"}
      assert PlayerList.retrieve(context[:list], {:private_id, "priv_0000"}) == { "0000", "priv_0000", "Jane"}
    end
    it "finds players by name", context do
      assert PlayerList.retrieve(context[:list], {:name, "awesome"}) == { "1234", "priv_1234", "awesome"}
      assert PlayerList.retrieve(context[:list], {:name, "Jane"}) == { "0000", "priv_0000", "Jane"}
    end

    @tag :focus
    it "fails to find non-existent players", context do
      assert PlayerList.retrieve(context[:list], "555") == nil
      assert PlayerList.retrieve(context[:list], { :private_id, "555"}) == nil
      assert PlayerList.retrieve(context[:list], { :name, "555"}) == nil
    end
  end

end
