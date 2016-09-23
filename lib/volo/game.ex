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

  def get_pid(game_pid, process_name) do
    GenServer.cast game_pid, {:get_pid, process_name}
  end

  def connect_player, do: nil
  def reconnect_player, do: nil
  def disconnect_player, do: nil
  def get_players, do: nil

  def via_tuple(game_number, type) do
    {:via, :gproc, { :n, :l, {game_number, type} } }
  end

  # Callbacks
  def init(game_number) do
    {:ok, %__MODULE__{ game_number: game_number }}
  end
  def handle_call({:get_pid, :world},   _from, state), do: state.processes.world
  def handle_call({:get_pid, :updater}, _from, state), do: state.processes.updater

end
