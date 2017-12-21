defmodule Parser.Subsections.EndStats do
  @behaviour Parser
  alias Parser.Readers.DomInteger
  def read!(input_bytestream) do
    <<count::integer-little-32>> = Enum.take(input_bytestream, 4)
    # positive count means 8 arrays of 16-bit (2-byte) ints, 200 entries/count
    # But I don't actually care about the contents at the moment, only the size
    if count > 0 do
      get_next = fn -> DomInteger.read!(input_bytestream, 2) end
      contents = for _ <- 1..(8*200*count), do: get_next.()
      {[count: count, contents: contents], :section, 8*200*count*2 + 4}
    else
      {[count: count], :section, 4}
    end
  end
end
