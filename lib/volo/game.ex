defmodule Volo.Game do
  use GenServer

  alias Volo.Game.PlayerList
  import Volo.Game.RegistryUtils

  defstruct players:    Volo.Game.PlayerList.new,
            start_time: Volo.Util.Time.now,
            game_id: nil,
            processes: %{}

  # API
  def start_link([game_id], opts \\ []) do
    GenServer.start_link(__MODULE__,
      [game_id],
      opts
    )
  end

  def connect_player(data) do
    Genserver.call(:connect_player, data)
  end
  def reconnect_player, do: nil
  def disconnect_player, do: nil
  def get_players, do: nil

  # Callbacks
  def init(game_id) do
    {:ok, %__MODULE__{ game_id: game_id }}
  end

  # def handle_call({ })

end
