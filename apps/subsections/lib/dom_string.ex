defmodule DomString do
  @moduledoc """
  Dominions XORs its strings by 0x4f before saving.
  """
  import Bitwise, only: [bxor: 2]

  def read(io_bytestream) do
    Enum.reduce_while(
      io_bytestream, <<>>,
      fn <<ch, _::binary>>, acc ->
        val = <<acc::binary, bxor(ch, 0x4f)>>
        if ch == 0x4f, do: {:halt, val}, else: {:cont, val}
      end)
  end
