defmodule Volo.Game.Updater do
  @moduledoc """
  A GenServer that handles periodically sampling the world state and
  sending each player their view of that state (as JSON over websocket),
  several times persecond.
  """

  use GenServer
  import Volo.Game.RegistryUtils

  def start_link(args) do
    IO.puts "Starting #{__MODULE__} with "
    IO.inspect args
    IO.puts "-----------"
    GenServer.start_link(__MODULE__, args, name: via_tuple(args, :updater))
  end

  def init(args) do
    { :ok, args }
  end


end
