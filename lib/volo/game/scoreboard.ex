defmodule Volo.Game.Scoreboard do
  @moduledoc """
  A GenServer that keeps track of score-related state, like shots fired,
  shots hit, tanks killed, etc.
  """
  defstruct game_number: nil

  use GenServer
  import Volo.Game.RegistryUtils

  # API
  def start_link([game_number]) do
    GenServer.start_link(__MODULE__, game_number,
      name: via_tuple(game_number, :scoreboard))
  end

  # GenServer Callbacks
  def init(game_number) do
    {:ok, %__MODULE__{ game_number: game_number }}
  end

end
