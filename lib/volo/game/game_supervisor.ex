defmodule Volo.Game.GameSupervisor do
  use Supervisor
  import Volo.Game.RegistryUtils


    @doc """
  Launch a new game and generate its supervision tree.  There will be
  a unique ID for the game, which will be used to identify all the
  processes.  It should look like this:

  game_sup_NNNNN         Game Supervisor, this module
   |-> game_NNNNN        Game metadata, Volo.Game
   |-> world_NNNNN       Game World, Volo.Game.World
   |-> updater_NNNNN     Outbound Communications updater, Volo.Game.Updater
   |-> scoreboard_NNNNN  Scoreboard, Volo.Game.Scoreboard
   |-> player_sup_NNNNN  Player Supervisor, Volo.Game.PlayerSupervisor

  An additional process for each player will be created as players join,
  supervised by player_sup_NNNNN.
  """
  def new_game do
    game_number = Volo.Util.ID.short
    {:ok, supervisor} = Supervisor.start_link(
      __MODULE__,
      [game_number],
      name: via_tuple(game_number, :game_supervisor)
    )
    { supervisor, game_number }
  end

  def init(game_number) do
    children = [
      worker(Volo.Game, [game_number]),
      worker(Volo.Game.Updater, [game_number]),
      worker(Volo.Game.World, [game_number]),
      worker(Volo.Game.Scoreboard, [game_number]),
      supervisor(Volo.Game.PlayerSupervisor, [game_number])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
