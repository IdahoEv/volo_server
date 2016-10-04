defmodule VoloServer do
  def start(_type, _args) do

    { pid, _game_id} = Volo.Game.GameSupervisor.new_game()
    { :ok, pid }
  end

end
