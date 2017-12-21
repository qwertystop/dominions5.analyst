defmodule Parser.Subsections.DelayedEvents do
  @behaviour Parser
  @moduledoc "Don't actually care about this but need to be sure of the size"
  alias Parser.Readers.DomInteger
  def read!(input_bytestream) do
    get_next = fn -> DomInteger.read!(input_bytestream, 4) end
    # Three arrays of int32 that share one leading index
    <<count::integer-little-32>> = Enum.take(input_bytestream, 4)
    [base, turn, lunar] =
      for(_ <- 1..count, do: {get_next.(), get_next.(), get_next.()})
        |> Enum.reduce([[],[],[]],
                       fn ({b, t, l}, [base, turn, lunar]) ->
                         [[b|base], [t|turn], [l|lunar]]
                       end)
    base = {Enum.reverse(base), {:list, :integer}, 4 * count}
    turn = {Enum.reverse(turn), {:list, :integer}, 4 * count}
    lunar = {Enum.reverse(lunar), {:list, :integer}, 4 * count}
    {[{"base", base}, {"turn", turn}, {"lunar", lunar}], :section, (count * 3 * 4) + 4}
  end
end
