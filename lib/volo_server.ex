defmodule VoloServer do
  def start(_type, _args) do
    Volo.Game.GameSupervisor.new_game() 
  end

end
