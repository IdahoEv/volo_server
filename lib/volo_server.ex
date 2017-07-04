defmodule VoloServer do
  
  def start(_type, _args) do
    { pid, game_id} = Volo.Game.GameSupervisor.new_game()
    Volo.Web.CowboyInit.start(nil, [game_id])
    { :ok, pid }
  end

end
