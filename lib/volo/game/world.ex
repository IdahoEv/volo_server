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
  defstruct game_number: nil

  use GenServer
  import Volo.Game.RegistryUtils

  # API
  def start_link([game_number]) do
    GenServer.start_link(__MODULE__, [game_number],
      name: via_tuple(game_number, :world))
  end

  # GenServer Callbacks
  def init(_) do
    { :ok, nil }
  end

end
