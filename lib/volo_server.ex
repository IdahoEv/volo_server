defmodule VoloServer do
  def start(_type, _args) do
    { pid, _game_number} = Volo.Game.GameSupervisor.new_game()
    { :ok, pid }
  end

end
