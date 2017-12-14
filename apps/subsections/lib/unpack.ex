defmodule Unpack do
  @type kind :: {:integer, :little | :big, pos_integer()}
  | {:binary} | {:binary, pos_integer()}
  | {:any}
  @type reader :: (Enumerable.t -> any()) # might be able to make this one more specific
  @type field :: {atom(), kind, reader}

  defmacro __using__(fields) do
    quote do
      defstruct unquote(for {name, _type, _reader} <- fields, do: name)
      unquote(make_unpack(fields, __ENV__.module))
    end
  end

  defp bit_type({:integer, :little, size}), do: quote(do: integer-little-unquote(size))
  defp bit_type({:integer, :big, size}), do: quote(do: integer-big-unquote(size))
  defp bit_type({:binary}), do: quote(do: binary)
  defp bit_type({:binary, size}), do: quote(do: binary-unquote(size))

  defp make_unpack(fields, module), do: make_unpack(fields, module, [], [])
  defp make_unpack([{name, kind, reader} | tail], module, acc_bind, acc_pairs) do
    var = Macro.var(name, module)
    input = Macro.var(:io_bytestream, module)

    bind = case kind do
      {:any} ->
        quote(do: unquote(var) = unquote(reader).(unquote(input)))
      _ ->
        quote(do: <<unquote(var)::unquote(bit_type(kind))>> = unquote(reader).(unquote(input)))
    end

    pair = quote(do: {unquote(name), unquote(var)})

    make_unpack(tail, module,
         [bind | acc_bind],
         [pair | acc_pairs]
    )
  end
  defp make_unpack([], module, acc_bind, acc_pairs) do
    binds = Enum.reverse(acc_bind)
    pairs = Enum.reverse(acc_pairs)
    quote do
      def unpack(io_bytestream) do
        unquote_splicing(binds)
        {:ok, %unquote(module){unquote_splicing(pairs)}}
      end
    end
  end
end
