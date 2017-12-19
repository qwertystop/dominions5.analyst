defmodule DelayedEvents do
  @moduledoc "Don't actually care about this but need to be sure of the size"
  defp read_triplearray(input_bytestream) do
    <<count::integer-little-32>> = Enum.take(input_bytestream, 4)
    contents = Enum.take(input_bytestream, count * 3)
    [count, for <<val::integer-little-32 <- contents>>, do: val]
  end
end
