defmodule Volo.Game.ProcessNames do

  @doc """
  ## examples
  iex> Volo.Game.ProcessNames.game(1234)
  "game_1234"
  """
  def game(num),              do: :"game_#{num}"
  def world(num),             do: :"world_#{num}"
  def updater(num),           do: :"updater_#{num}"
  def scoreboard(num),        do: :"scoreboard_#{num}"
  def player_supervisor(num), do: :"player_sup_#{num}"
  def game_supervisor(num),   do: :"game_sup_#{num}"
end
