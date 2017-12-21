defmodule Readers.DomString do
  @moduledoc """
  Dominions XORs its strings by 0x4f before saving.
  """
  import Bitwise, only: [bxor: 2]

  @spec read!(Enumerable.t, keyword) :: Parser.field
  def read!(input_bytestream, mask: mask) do
    <<value::binary>> = Enum.reduce_while(
      input_bytestream, <<>>,
      fn <<ch::8>>, acc ->
        val = <<acc::binary, bxor(ch, mask)>>
        if ch == mask, do: {:halt, val}, else: {:cont, val}
      end)
      {value, :string, byte_size(value)}
  end

  def read!(input_bytestream, length: count, mask: mask)
  when count >= 1 do
    <<value::binary>> = for <<c::8>> <-
      Enum.take(input_bytestream, count),
      into: <<>>,
      do: bxor(c, mask)
    {value, :string, count}
  end

  def read!(input_bytestream, []), do: read!(input_bytestream, mask: 0x4f)
  def read!(input_bytestream, length: count),
    do: read!(input_bytestream, length: count, mask: 0x4f)
end
