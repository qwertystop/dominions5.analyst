defmodule Parser.Readers.DomInteger do
  def read!(input_bytestream, count) do
    bitsize = count * 8
    <<value::integer-little-size(bitsize)>> = Enum.take(input_bytestream, count)
    {value, :integer, count}
  end

  def read!(input_bytestream, count, :signed), do: read!(input_bytestream, count)
  def read!(input_bytestream, count, :unsigned) do
    bitsize = count * 8
    <<value::integer-little-unsigned-size(bitsize)>> = Enum.take(input_bytestream, count)
    {value, :integer, count}
  end
end
