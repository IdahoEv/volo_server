defmodule Volo.Game.Player do
  use GenServer
  import Volo.Game.RegistryUtils
  import Apex.AwesomeDef

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
             game_id:       "",
             websocket_pid: :""
             # , control_state


  def start_link(name, game_id, websocket_pid) do
    # IO.puts "Specific start_link/2 matched in Player"
    GenServer.start_link(__MODULE__,
      [name, game_id, websocket_pid],
      []
    )
  end

  def get_state(pid), do: GenServer.call(pid, :get_state)


  def init([name, game_id, websocket_pid]) do
    id = Volo.Util.ID.short
    :gproc.reg gproc_regkey(game_id, :player, id), self
    label_player_for_development(__MODULE__, game_id, id)

    { :ok,
      %__MODULE__{
        game_id:        game_id,
        id:             id,
        private_id:     Volo.Util.ID.long,
        name:           name,
        websocket_pid:  websocket_pid
    }}
  end

  def handle_call(:get_state, _from, state), do: { :reply, state, state }

end
