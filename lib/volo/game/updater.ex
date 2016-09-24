defmodule Volo.Game.Updater do
  @moduledoc """
  A GenServer that handles periodically sampling the world state and
  sending each player their view of that state (as JSON over websocket),
  several times persecond.
  """

  defstruct game_number: nil

  use GenServer
  import Volo.Game.RegistryUtils

  def start_link([game_number]) do
    GenServer.start_link(__MODULE__, [game_number],
      name: via_tuple([game_number], :updater))
  end

  # GenServer Callbacks
  def init(game_number) do
    {:ok, %__MODULE__{ game_number: game_number }}
  end

end
