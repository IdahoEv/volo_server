defmodule Volo.Game.RegistryUtils do

  @doc """
  A tuple instructing OTP to register this process's name with
  :gproc instead of Process.  See:
  http://elixir-lang.org/docs/stable/elixir/GenServer.html#module-name-registration
  https://m.alphasights.com/process-registry-in-elixir-a-practical-example-4500ee7c0dcc#.gud45965x
  https://github.com/uwiger/gproc/tree/master/doc
  """
  def via_tuple(game_id, name) do
    { :via, :gproc, gproc_regkey(game_id, name) }
  end
  def via_tuple(game_id, :player, player_id) do
    { :via, :gproc, gproc_regkey(game_id, :player, player_id) }
  end

  def gproc_regkey(game_id, name), do: { :n, :l, gproc_key(game_id, name)}
  def gproc_key(game_id, name ), do: { game_id, name}

  def gproc_regkey(game_id, :player, player_id) do
    { :n, :l, gproc_key(game_id, player_id) }
  end
  def gproc_key(game_id, :player, player_id ) do
    { game_id, :player, player_id }
  end
  
  def get_pid(game_id, name) do
    :gproc.lookup_pid(gproc_regkey(game_id, name))
  end
  def get_pid(game_id, :player, name) do
    :gproc.lookup_pid(gproc_regkey(game_id, :player, name))
  end


  def label_for_development(module_name, game_id) do
    if Application.get_env(:volo_server, :dynamic_atom_process_labels) do
      Process.register(self, :"#{module_name}-#{game_id}")
    end
  end

  def label_player_for_development(mod, game_id, player_id) do
    if Application.get_env(:volo_server, :dynamic_atom_process_labels) do
      Process.register(self, :"#{mod}-#{game_id}-#{player_id}")
    end
  end
end
