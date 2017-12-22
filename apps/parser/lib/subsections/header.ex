defmodule Parser.Subsections.Header do
  @behaviour Parser
  @moduledoc """
  Header of all Dom5 files
  """
  alias Parser.Readers.{DomString,DomInteger}
  def read!(input) do
    # Sentinel first
    <<0x01, 0x02, 0x04, 0x44, 0x4f, 0x4d>> = Enum.take(input, 6)
    parsed = [
      user_id: DomInteger.read!(input, 4),
      game_version: DomInteger.read!(input, 4),
      turn_number: DomInteger.read!(input, 4),
      unk00: DomInteger.read!(input, 4),
      unk01: DomInteger.read!(input, 4),
      realm_id: DomInteger.read!(input, 4),
      unk02: DomInteger.read!(input, 4),
      unk03: DomInteger.read!(input, 4),
      game_name: DomString.read!(input),
      password: DomString.read!(input, mask: 0x78),
      master_password: DomString.read!(input, mask: 0x78),
      turn_key: DomInteger.read!(input, 4)
    ]
    {parsed, :section,
      Enum.reduce(parsed, 0, fn {_, _, size}, acc -> acc + size end)}
  end
end
