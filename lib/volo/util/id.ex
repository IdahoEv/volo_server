defmodule Volo.Util.ID do
  @moduledoc """
  Functions for generating unique IDs and similar.
  """

  def short do
    :erlang.unique_integer([:positive]) |> to_string
  end

  def long do
    UUID.uuid1
  end

end
