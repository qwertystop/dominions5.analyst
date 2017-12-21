defmodule Parser.Readers.DomFloat do
  def read!(input, count) do
    bitsize = count * 8
    <<val::float-little-size(bitsize)>> = Enum.take(input, count)
    {val, :float, count}
  end
end
