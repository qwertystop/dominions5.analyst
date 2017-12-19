defmodule Parser.Subsections.Dominion do
  import Parser.Unpack
  use Parser.Unpack, [
    unknown(:bytes6, 6), string(:name),
    unknown(:u32_00), unknown(:u32_01),
    map(:unknownMap, {:integer, 4}, {:integer, 4})
  ]
end
