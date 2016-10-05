defmodule Volo.Web.WebsocketHandler do
  import Apex.AwesomeDef
  @behaviour :cowboy_websocket_handler

  alias Volo.Game
  alias Volo.Game.Player

  defstruct player_pid: nil,
            private_id: nil,
            game_id: nil

  def init(req, state) do
    IO.puts "\nWSH init running:"
    IO.inspect state
    {:cowboy_websocket, req, state}
  end

  adef terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle({:text, msg}, req, state) do
    IO.puts "Incoming message on websocket #{self()}"
    IO.inspect msg
    IO.inspect state
    IO.inspect self
    data = Poison.Parser.parse!(msg, as: %{})
    IO.inspect data
    handle_message(data, req, state)
  end

  def handle_message(%{ connect: data }, req, state) do
    case Game.connect_player(data) do
      { :ok, player, game_id } -> successful_connection(player)
      { :error, reason } -> failed_connection(reason)
    end
    |> reply(req, state)
  end

  def handle_message(data, req, state) do
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
