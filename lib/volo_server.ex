defmodule VoloServer do
  import Volo.Game.RegistryUtils
  
  
  def start(_type, _args) do
    { pid, game_id} = Volo.Game.GameSupervisor.new_game()
    Trace.i game_id, "Started game.  ID is:"
    Volo.Web.CowboyInit.start(nil, [game_id])
    { :ok, pid }
  end

end
