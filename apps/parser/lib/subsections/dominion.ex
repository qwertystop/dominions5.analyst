defmodule Parser.Subsections.Dominion do
  @behaviour Parser
  alias Parser.Readers.{Bytes,DomInteger,DomString,DomMap}
  @constant_part_size 6+4+4
  def read!(input) do
    unknownBytes = Bytes.read!(input, 6)
    name = {_, :string, nameSize} = DomString.read!(input)
    u32_00 = DomInteger.read!(input, 4, :unsigned)
    u32_01 = DomInteger.read!(input, 4, :unsigned)
    unknownMap = {_, {:map, :integer}, mapSize} = DomMap.read!(input, {:integer, 4}, {:integer, 4})
    {[{"unknown bytes", unknownBytes},
      {"name", name},
      {"u32_00", u32_00},
      {"u32_01", u32_01},
      {"unknown map", unknownMap}],
     :section, @constant_part_size + nameSize + mapSize}
  end
end
