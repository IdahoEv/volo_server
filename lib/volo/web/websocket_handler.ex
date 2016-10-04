defmodule WebsocketHandler do
  import Apex.AwesomeDef
  @behavior :cowboy_websocket_handler

  alias Volo.Game
  alias Volo.Game.Player

  defstruct player_pid: nil,
            private_id: nil,
            game_id: nil

  adef init(req, state) do
    # :erlang.start_timer(1000, self, [])
    {:cowboy_websocket, req, state}
  end

  def terminate do
    :ok
  end

  def websocket_handle({:text, msg}, req, state) do
    IO.puts "Incoming message on websocket #{self()}"
    IO.inspect msg
    data = Poison.Parser.parse!(msg, as: %{})
    IO.inspect data
    handle_message(data, req, state)
  end

  def handle_message(%{ connect: data }, req, state) do
    case Game.register_player(data) do
      { :ok, player, game_id } -> successful_connection(player)
      { :error, reason } -> failed_connection(reason)
    end
    |> reply(req, state)
  end

  def handle_message(data, state) do
    { :ok, state }
  end

  defp successful_connection(player) do
    Poison.encode %{ connected: %{
      private_id: player.private_id,
      game_id: player.game_id
    }}
  end

  defp failed_connection(reason) do
    Poison.encode %{ connection_failed: reason }
  end

  defp reply(message, req, state) do
    { :reply, { :text, message}, req, state}
  end
end
