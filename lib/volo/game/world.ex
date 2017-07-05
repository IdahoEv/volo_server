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
  defstruct game_id: nil

  use GenServer
  import Volo.Game.RegistryUtils

  # API
  def start_link([game_id], opts \\ []) do
    GenServer.start_link(__MODULE__, [game_id],
      Keyword.merge(opts, name: via_tuple(game_id, :world)))
  end

  # GenServer Callbacks
  def init(game_id) do
    label_for_development(__MODULE__, game_id)

    { :ok, nil }
  end

end
