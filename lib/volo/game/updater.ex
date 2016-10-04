defmodule Volo.Game.Updater do
  @moduledoc """
  A GenServer that handles periodically sampling the world state and
  sending each player their view of that state (as JSON over websocket),
  several times persecond.
  """

  defstruct game_id: nil

  use GenServer
  import Volo.Game.RegistryUtils

  def start_link([game_id]) do
    GenServer.start_link(__MODULE__, [game_id],
      name: via_tuple([game_id], :updater))
  end

  # GenServer Callbacks
  def init(game_id) do
    {:ok, %__MODULE__{ game_id: game_id }}
  end

end
