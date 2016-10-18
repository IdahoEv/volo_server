defmodule Volo.Game.PlayerList do
  @moduledoc """
  The list of players connected to a game.  Stored in a map with player public
  IDs as keys, with the tuple of public id, private id, and name as values.

  Useful for things like: checking if the game is at max number of players,
  looking up to see if someone is already using a certain name in this game,
  finding a player's info if they are reconnecting by private ID, etc.
  """
  def new do
    Map.new
  end

  def store(list, player_id, private_id, name) do
    Dict.put(list, player_id, { player_id, private_id, name } )
  end

  def retrieve(list, { :private_id, private_id }) do
    case Dict.values(list)
           |> Enum.find(fn({_, priv_id, _}) -> priv_id == private_id end) do
      nil    -> :not_found
      tuple -> tuple
    end
  end

  def retrieve(list, { :name, name }) do
    case Dict.values(list)
           |> Enum.find(fn({_, _, nm}) -> nm == name end) do
      nil    -> :not_found
      tuple -> tuple
    end
  end


  def retrieve(list, player_id) do
    case Dict.fetch(list, player_id) do
     :error         -> :not_found
     { :ok, tuple } -> tuple
    end
  end
end
