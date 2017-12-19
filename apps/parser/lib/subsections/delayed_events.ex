defmodule DelayedEvents do
  @moduledoc "Don't actually care about this but need to be sure of the size"
  defp read_triplearray(input_bytestream) do
    <<count::integer-little-32>> = Enum.take(input_bytestream, 4)
    contents = Enum.take(input_bytestream, count * 3)
    result = [count, (for <<val::integer-little-32 <- contents>>, do: val)]
    {result, :special, count * 3 + 1}
  end

  import Parser.Unpack
  use Parser.Unpack, [
    special(:event_array, read_triplearray/1)
  ]
end
