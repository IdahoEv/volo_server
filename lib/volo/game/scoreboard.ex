defmodule Volo.Game.Scoreboard do
  @moduledoc """
  A GenServer that keeps track of score-related state, like shots fired,
  shots hit, tanks killed, etc.
  """

  use GenServer
  import Volo.Game.RegistryUtils

  # API
  def start_link(args) do
    IO.puts "Starting #{__MODULE__} with "
    IO.inspect args
    IO.puts "-----------"
    GenServer.start_link(__MODULE__, args, name: via_tuple(args, :scoreboard))
  end

  # GenServer Callbacks
  def init(args) do
    { :ok, args }
  end


end
