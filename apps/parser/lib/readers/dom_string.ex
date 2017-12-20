defmodule Readers.DomString do
  @moduledoc """
  Dominions XORs its strings by 0x4f before saving.
  """
  import Bitwise, only: [bxor: 2]

  def read(input_bytestream) do
    <<value::binary>> = Enum.reduce_while(
      input_bytestream, <<>>,
      fn <<ch::8>>, acc ->
        val = <<acc::binary, bxor(ch, 0x4f)>>
        if ch == 0x4f, do: {:halt, val}, else: {:cont, val}
      end)
      {value, :string, byte_size(value)}
  end

  def read(input_bytestream, count) do
    <<value::binary>> = for <<c::8>> <-
      Enum.take(input_bytestream, count),
      into: <<>>,
      do: bxor(c, 0x4f)
    {value, :string, count}
  end
end
