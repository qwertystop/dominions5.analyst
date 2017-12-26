defmodule Parser.Subsections.Land do
  alias Parser.Readers.{Bytes,DomInteger,DomString}

  defmodule InFatherland do
    def read!(input) do
      parsed = [
        name: DomString.read!(input, length: 36),
        unk00: DomInteger.read!(input, 2),
        sites: Bytes.read!(input, 16),
        unrest: DomInteger.read!(input, 2),
        rec1: DomInteger.read!(input, 2),
        rec2: DomInteger.read!(input, 2),
        unk01: DomInteger.read!(input, 2),
        resource: DomInteger.read!(input, 2),
        own1: DomInteger.read!(input, 2),
        own2: DomInteger.read!(input, 2),
        own3: DomInteger.read!(input, 2),
        lab0: Bytes.read!(input, 1),
        lab1: Bytes.read!(input, 1),
        temple: Bytes.read!(input, 1),
        fort: DomInteger.read!(input, 1),
      ]
      # then the common tail
      Parser.Subsections.Land.common_tail(input, parsed)
    end
  end

  defmodule Outside do
    def read!(input) do
      parsed = [
        # padding - don't know what this represents yet
        padding: Bytes.read!(input, 40)
      ]
      # then the common tail
      Parser.Subsections.Land.common_tail(input, parsed)
    end
  end

  def common_tail(input, head) do
    [
      defence: DomInteger.read!(input, 1),
      unk_tail: Bytes.read!(input, 6),
      poptype: DomInteger.read!(input, 1),
      revealed: Bytes.read!(input, 8),
      # this one is weird and irrelevant-as-far-as-I-can-tell
      # so I'm only parsing it enough to get the right length
      land_info_mess: Enum.reduce_while(input, [], fn (inp, acc) ->
        <<flag::integer-8>> = Enum.take(inp, 1)
        if flag == 0xFF do
          {:halt,
            {Enum.reverse([<<flag>> | acc]), :bytes, length(acc) * 3 + 1}}
        else
          <<rest::binary-2>> = Enum.take(inp, 2)
          {:cont, [(flag <> rest) | acc]}
        end
      end),
      rec_arr_1: Bytes.read!(input, Keyword.get(head, :rec1) |> elem(0)),
      rec_arr_2: Bytes.read!(input, Keyword.get(head, :rec2) |> elem(0)),
      unk_tail_2: Bytes.read!(input, 8),
      # now here's a chunk that depends on how we started
      # either way it's 10 bytes and I don't see a use
      variable: Bytes.read!(input, 10),
      unk_tail_3: Bytes.read!(input, 2),
      terrain: DomInteger.read!(input, 4),
      geom_x: DomInteger.read!(input, 2),
      geom_y: DomInteger.read!(input, 2),
      neighbors: Bytes.read!(input, 40),
      unk_tail_4: Bytes.read!(input, 4),
      unk_str_1: DomString.read!(input),
      unk_str_1: DomString.read!(input),
      unk_tail_5: Bytes.read!(input, 22),
      padding: Bytes.read!(input, 15)
      # TODO this isn't done yet but I'm feeling very much at sea.
    ]
  end
end
