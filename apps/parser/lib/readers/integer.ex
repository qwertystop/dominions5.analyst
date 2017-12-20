defmodule Parser.Readers.Integer do
  def read(input_bytestream, count) do
    <<value::integer-little-size(count)>> = Enum.take(input_bytestream, count)
    {value, :integer, count}
  end
end
