defmodule Parser.Readers.Bytes do
  @moduledoc """
  For sequences of bytes, type unknown
  """
  @spec read!(Enumerable.t, pos_integer) :: {binary, :bytes, pos_integer}
  def read!(input_bytestream, count) do
    value = for <<b::binary-1 <- Enum.take(input_bytestream, count)>>, do: b
    {value, :bytes, count}
  end
end
