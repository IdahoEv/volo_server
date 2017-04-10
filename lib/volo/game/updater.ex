defmodule Volo.Game.Updater do
  @moduledoc """
  A GenServer that handles periodically sampling the world state and
  sending each player their view of that state (as JSON over websocket),
  several times persecond.
  """

  defstruct game_id: nil

  use GenServer
  import Volo.Game.RegistryUtils

  def start_link([game_id], opts \\ []) do
    GenServer.start_link(__MODULE__, [game_id],
      Keyword.merge(opts, name: via_tuple(game_id, :updater)))
  end

  # GenServer Callbacks
  def init(game_id) do
    label_for_development(__MODULE__, game_id)

    {:ok, %__MODULE__{ game_id: game_id }}
  end

end
