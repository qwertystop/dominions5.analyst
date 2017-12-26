defmodule Parser.Subsections.Kingdom do
  @behaviour Parser
  alias Parser.Readers.{Bytes,DomInteger,DomString}

  def read!(input) do
    # first a sentinel, should be 12346
    # according to reference, its 2 bytes but read as int32?
    # simpler to not bother checking for now
    # TODO actually check sentinel value
    sentinel = DomInteger.read!(input, 2)
    unk_int32_1 = DomInteger.read!(input, 4)
    # then there's a lot of unknown stuff
    block_1 = Bytes.read!(input, 28 * 2)
    count_block_2 = DomInteger.read!(input, 4)
    parsed = [
      sentinel: sentinel,
      unk_int32_1: unk_int32_1,
      block_1: block_1,
      count_block_2: count_block_2,
      block_2: Bytes.read!(input, 2 * count_block_2),
      block_3: Bytes.read!(input, 29 * 2),
      leader_name: DomString.read!(input),
      block_4: Bytes.read!(input, 81 * 2),
      unk_int16: DomInteger.read!(input, 2),
      block_5: Bytes.read!(input, 600 * 2),
      unk_int32_2: DomInteger.read!(input, 4)
    ]
    {parsed, :section,
      Enum.reduce(parsed, 0, fn {_, _, size}, acc -> acc + size end)}
  end
end
