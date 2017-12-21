defmodule Parser.Subsections.EnchantmentData do
  @behaviour Parser
  alias Parser.Readers.DomInteger
  def read!(input) do
    # define necessary readers
    u32 = fn -> DomInteger.read!(input, 4, :unsigned) end
    u16 = fn -> DomInteger.read!(input, 2, :unsigned) end
    # sentinel is the only signed value here
    parsed = [
      sentinel: DomInteger.read!(input, 2),
      u32_00: u32.(), u16_00: u16.(), u16_01: u16.(), u16_02: u16.(),
      u16_03: u16.(), u16_04: u16.(), u16_05: u16.(), u32_01: u32.(),
      u32_02: u32.(), u32_03: u32.(), u32_04: u32.(), u32_05: u32.(),
      u16_06: u16.()]
    {parsed, :section, 4*6 + 2*8}
  end
end
