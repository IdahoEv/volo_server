defmodule PlayerListTest do
  use ExSpec, async: true

  alias Volo.Game.PlayerList
  doctest Volo.Game.PlayerList

  describe "looking up players" do
    setup _ do
      list = PlayerList.new
      |> PlayerList.store("1234", "priv_1234", "awesome")
      |> PlayerList.store("0000", "priv_0000", "Jane")
      [ list: list ]
    end

    @tag :focus
    it "finds players by id", data do
      # Trace.ap data, "data"
      assert PlayerList.retrieve(data[:list], "1234") == { "1234", "priv_1234", "awesome"}
      assert PlayerList.retrieve(data[:list], "0000") == { "0000", "priv_0000", "Jane"}
    end

    it "finds players by private_id", data do
      assert PlayerList.retrieve(data[:list], {:private_id, "priv_1234"}) == { "1234", "priv_1234", "awesome"}
      assert PlayerList.retrieve(data[:list], {:private_id, "priv_0000"}) == { "0000", "priv_0000", "Jane"}
    end
    it "finds players by name", data do
      assert PlayerList.retrieve(data[:list], {:name, "awesome"}) == { "1234", "priv_1234", "awesome"}
      assert PlayerList.retrieve(data[:list], {:name, "Jane"}) == { "0000", "priv_0000", "Jane"}
    end

    @tag :focus
    it "fails to find non-existent players", data do
      assert PlayerList.retrieve(data[:list], "555") == nil
      assert PlayerList.retrieve(data[:list], { :private_id, "555"}) == nil
      assert PlayerList.retrieve(data[:list], { :name, "555"}) == nil
    end
  end

end
