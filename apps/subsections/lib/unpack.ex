defmodule Unpack do
  @type kind :: {:integer, :little | :big, pos_integer()}
  | {:binary} | {:binary, pos_integer()}
  | {:any}
  @type reader :: (Enumerable.t) -> any() # might be able to make this one more specific
  @type field :: {atom(), kind, reader}

  defmacro __using__(fields) do
    quote do
      defstruct unquote(for {name, _type, _reader} <- fields, do: name)
      @type t :: %unquote(__ENV__.module){
        unquote_splicing(
          for {name, kind, _reader} <- fields, do: {name, spec_type(kind)}
        )
      }
      unquote(makefun(fieldss, __ENV__.module))
    end
  end

  defp spec_type({:integer, _, _}) do: integer()
  defp spec_type({:binary}) do: binary()
  defp spec_type({:binary, _}) do: binary()
  defp spec_type({:any}) do: any()

  defp bit_type({:integer, :little, size}) do: quote(integer-little-unquote(size))
  defp bit_type({:integer, :big, size}) do: quote(integer-big-unquote(size))
  defp bit_type({:binary}) do: quote(binary)
  defp bit_type({:binary, size}) do: quote(binary-unquote(size))

  defp makefun(args, module) do: funs(fields, module, [], [])
  defp makefun([{name, kind, reader} | tail], module, acc_bind, acc_pairs) do
    var = Macro.var(name, module)
    input = Macro.var(:io_bytestream, module)
    
    bind = case kind do
      {:any} ->
        quote(unquote(var) = unquote(reader).(unquote(input)))
      _ ->
        quote(<<unquote(var)::unquote(bit_type(kind))>> = unquote(reader).(unquote(input)))

    pair = quote({unquote(name), unquote(var)})
    
    funs(tail, module,
         [bind | acc_bind],
         [pair | acc_pairs]
    )
  end
  defp makefun([], module, acc_bind, acc_pairs) do
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
