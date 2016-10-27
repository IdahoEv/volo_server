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
    GenServer.start_link(__MODULE__,
      [name, game_id, websocket_pid],
      []
    )
  end

  @doc """
  Retrieve this server's state as a map.
  """
  def get_state(pid), do: GenServer.call(pid, :get_state)
  
  @doc """
  Update the websocket connection for this player - used when a player
  reconnects.  Returns the updated state of the player.
  """
  def update_websocket(pid, ws_pid), do: GenServer.call(pid, {:update_websocket, ws_pid})
  
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
  def handle_call({ :update_websocket, ws_pid}, _from, state) do
   state = %__MODULE__{ state | websocket_pid: ws_pid }
   { :reply, state, state }
  end

end
