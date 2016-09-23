defmodule IDTest do
  use ExSpec, async: true

  describe "short" do
    it "should return a string" do
      assert String.valid?(Volo.Util.ID.short)
    end

    it "should return unique strings when called many times" do
      ids = 1..1000 |> Enum.map(fn(_) -> Volo.Util.ID.short end)
      assert ids -- Enum.dedup(ids) == []
    end
  end
end
