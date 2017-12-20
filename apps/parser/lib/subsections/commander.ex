defmodule Parser.Subsections.Commander do
  @behaviour Parser
  @constant_size (10 * 4) + (26 * 2) + 51
  alias Parser.Readers.{Bytes,DomString,DomInteger}
  def read!(input) do
    name = {_, :string, nameLength} = DomString.read(input)
    blockspecs = [{0, 5, 4}, {0, 15, 2}, {6, 9, 4}, {16, 24, 2}]
    unknown_block = for {low, high, size} <- blockspecs,
      i <- low..high,
      do: {
        "u" <> Integer.to_string(size) <> "_" <> Integer.to_string(i),
        DomInteger.read(input, size, :unsigned)}
    unknown_bytes = {"unknown bytes", Bytes.read(input, 51)}
    final_unknown = {"u16_25", DomInteger.read(input, 2)}
    # need one list without accidentally flattening tuples,
    # so we can't easily Enum.concat
    result = [name | [unknown_block | [unknown_bytes | final_unknown]]]
    {result, nameLength + @constant_size}
  end
end
