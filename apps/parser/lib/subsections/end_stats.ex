defmodule Parser.Subsections.EndStats do
  @moduledoc "Don't actually care about this but need to be sure of the size"
  defp read_endstats(input_bytestream) do
    <<count::integer-little-32>> = Enum.take(input_bytestream, 4)
    if count > 0 do
      # positive count means eight arrays of 16-bit (2-byte) ints, with 200 entries per count
      contents = Enum.take(input_bytestream, 8 * 2 * 200 * count)
      result = [count, (for <<val::integer-little-16 <- contents>>, do: val)]
      {result, :unknown, count * 3 + 1}
    else
      {count, :unknown, 4}
    end
  end

  use Parser.Unpack, [
    unknown(:endstats, read_endstats/1)
  ]
end
