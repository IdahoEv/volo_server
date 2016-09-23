defmodule Volo.Game.World do
  @moduledoc """
  Module for managing and updating the state of the game world, including:
    * map and terrain
    * projectiles
    * physics state of tanks
    * mines
    * pillboxes
    * bases

  This module manages a GenServer that handles the fast game update
  loop.
  """

  use GenServer
  import Volo.Game.RegistryUtils

  # API
  def start_link(args) do
    IO.puts "Starting #{__MODULE__} with "
    IO.inspect args
    IO.puts "-----------"
    GenServer.start_link(__MODULE__, args, name: via_tuple(args, :world))
  end

  # GenServer Callbacks
  def init(_) do
    { :ok, nil }
  end

end
