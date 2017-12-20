defmodule Parser.Readers.DomInteger do
  def read(input_bytestream, count) do
    <<value::integer-little-size(count)>> = Enum.take(input_bytestream, count)
    {value, :integer, count}
  end

  def read(input_bytestream, count, :signed), do: read(input_bytestream, count)
  def read(input_bytestream, count, :unsigned) do
    <<value::integer-little-unsigned-size(count)>> = Enum.take(input_bytestream, count)
    {value, :integer, count}
  end
end
