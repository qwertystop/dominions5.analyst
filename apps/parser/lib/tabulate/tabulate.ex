defmodule Parser.Tabulate do
  require EEx
  EEx.function_from_file(:def, :table, "templates/table.eex", [:contents])

  def tabulate(parsed) do
    parsed |> prep_contents |> table
  end

  @spec prep_contents([{atom, {any, atom, pos_integer}}...]) ::
        [{pos_integer, atom, atom, any}]
  def prep_contents(parsed) do
    parsed
    |> Enum.reduce([{0, :dummy, :dummy, :dummy}],
                   fn({name, {val, type, size}}, tail=[{offset,_,_,_}|_rest]) do
                        value = construct_value(val, type)
                        [{size + offset, name, type, val} | tail]
                   end
    )
    |> Enum.reverse
    # get rid of the dummy acc
    |> tl
  end

  def construct_value(val, :integer), do: val
  def construct_value(val, :binary), do: val
  def construct_value(val, :unknown), do: "0x" + Base.encode16(val)
end
