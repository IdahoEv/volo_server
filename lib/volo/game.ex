defmodule Volo.Game do
  use GenServer

  alias Volo.Game.PlayerList
  import Volo.Game.RegistryUtils

  defstruct players:    Volo.Game.PlayerList.new,
            start_time: Volo.Util.Time.now,
            game_number: nil,
            processes: %{}

  # API
  def start_link([game_number], opts \\ []) do
    GenServer.start_link(__MODULE__,
      [game_number],
      opts
    )
  end

  def connect_player, do: nil
  def reconnect_player, do: nil
  def disconnect_player, do: nil
  def get_players, do: nil

  # Callbacks
  def init(game_number) do
    {:ok, %__MODULE__{ game_number: game_number }}
  end

end
