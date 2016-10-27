defmodule Volo.Game.Scoreboard do
  @moduledoc """
  A GenServer that keeps track of score-related state, like shots fired,
  shots hit, tanks killed, etc.
  """
  defstruct game_id: nil

  use GenServer
  import Volo.Game.RegistryUtils

  # API
  def start_link([game_id]) do
    GenServer.start_link(__MODULE__, game_id,
      name: via_tuple(game_id, :scoreboard))
  end

  # GenServer Callbacks
  def init(game_id) do
    label_for_development(__MODULE__, game_id)

    {:ok, %__MODULE__{ game_id: game_id }}
  end

end
