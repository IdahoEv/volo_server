defmodule Volo.Game.RegistryUtils do

  @doc """
  A tuple instructing OTP to register this process's name with
  :gproc instead of Process.  See:
  http://elixir-lang.org/docs/stable/elixir/GenServer.html#module-name-registration
  https://m.alphasights.com/process-registry-in-elixir-a-practical-example-4500ee7c0dcc#.gud45965x
  https://github.com/uwiger/gproc/tree/master/doc
  """
  def via_tuple(game_id, process_name) do
    { :via, :gproc, { :n, :l, { game_id, process_name }}}
  end
end
