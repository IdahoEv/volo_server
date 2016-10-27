defmodule Trace do

  def ap(value, label) do
    IO.puts "****************** #{inspect label}"
    Apex.ap value
  end

  def i(value, label) do
    IO.puts "****************** #{inspect label}"
    IO.inspect value
  end

end
