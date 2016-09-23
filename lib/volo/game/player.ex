defmodule Volo.Game.Player do
  @moduledoc """
  A Player represents a single user playing a specific game.  This struct
  effectively just contains the metadata identifying the player and
  their associated processes.

  References are stored to the tank process, game process, and websocket process.
  """

  defstruct  id:            "", # Global identifier, present in all updates
             private_id:    "", # Identifier shared only with the player.
                                # This one is required to reconnect to a game
                                # if the websocket is lost, so the client should
                                # store it.
             name:          "", # Player's visible name
             tank_pid:      "",
             game_pid:      :game,
             websocket_pid: :""

  def new(name, websocket_pid) do
    %__MODULE__{
      id:             Volo.Util.ID.short,
      private_id:     Volo.Util.ID.long,
      name:           name,
      websocket_pid:  websocket_pid
    }
  end
end
