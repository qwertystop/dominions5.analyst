defmodule Unpack do
  @type kind :: {{:integer, :little | :big}, pos_integer()}
  | :binary | {:binary, pos_integer()}
  | {:unknown, pos_integer()}
  # might be able to make this one more specific
  @type reader :: :default
  | (Enumerable.t -> {integer() | binary(), pos_integer()})
  @type field :: {atom(), kind, reader}


  # Macros for more convenient type specifiers
  defmacro int32_l(name), do: quote do: {unquote(name), {{:integer, :little}, 4}, :default}
  defmacro int32_b(name), do: quote do: {unquote(name), {{:integer, :big}, 4}, :default}
  defmacro int16_l(name), do: quote do: {unquote(name), {{:integer, :little}, 2}, :default}
  defmacro int16_b(name), do: quote do: {unquote(name), {{:integer, :big}, 2}, :default}
  defmacro int8_l(name),  do: quote do: {unquote(name), {{:integer, :little}, 1}, :default}
  defmacro int8_b(name),  do: quote do: {unquote(name), {{:integer, :big}, 1}, :default}
  defmacro string(name, reader) when is_function(reader, 0),  do: quote do: {unquote(name), :binary, unquote(reader)}
  defmacro string(name, size) when is_integer(size),  do: quote do: {unquote(name), {:binary, unqote(size)}, :default}
  defmacro string(name, size, reader),  do: quote do: {unquote(name), {:binary, unquote(size)}, unquote(reader)}

  defmacro __using__(fields) do
    field_vals = for {:{}, _, [name, kind, reader]} <- fields, do: {name, kind, reader}
    field_kinds = for {name, kind, _reader} <- field_vals, do: {name, kind}
    quote do
      defstruct unquote(for {name, _kind, _reader} <- field_vals, do: name)
      @field_kinds unquote(field_kinds)
      unquote(make_unpack(field_vals, __CALLER__))
    end
  end

  # integers are sized in bits, but we get sizes in bytes
  defp bit_type({{:integer, :little}, size}), do: quote do: integer-little-unquote(size * 8)
  defp bit_type({{:integer, :big}, size}), do: quote do: integer-big-unquote(size * 8)
  defp bit_type({:binary, size}), do: quote do: binary-unquote(size)

  defp make_unpack(fields, module), do: make_unpack(fields, module, [], [])
  defp make_unpack([{name, kind, reader} | tail], module, acc_bind, acc_pairs) do
    var = Macro.var(name, __MODULE__)
    input = Macro.var(:io_bytestream, __MODULE__)
    reader = if reader == :default do
      {_, size} = kind
      quote(do: Enum.take(unquote(input), unquote(size)))
    else
      quote(do: unquote(reader).(unquote(input)))
    end

    bind = case kind do
      # match through the pattern, but var is still the whole tuple
      {:unknown, size} ->
        quote(do: unquote(var) = {_, unquote(size)} = unquote(reader))
      {_, size} ->
        quote(do: unquote(var) =
          {<<_::unquote(bit_type(kind))>>, unquote(size)} = unquote(reader))
      :binary ->
        quote(do: unquote(var) = {<<_::binary>>, _} = unquote(reader))
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
