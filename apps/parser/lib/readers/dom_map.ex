defmodule Parser.Readers.DomMap do
  @type subspec :: {atom, any}

  @spec read!(Enumerable.t, subspec, subspec) :: Parser.collection
  def read!(input_bytestream, {key_type=:integer, key_size}, {val_type, val_spec}) do
    read_key(input_bytestream, key_type, key_size, val_type, val_spec)
  end

  defp delegate_reader(input_bytestream, :integer, size) do
    Parser.Readers.DomInteger.read!(input_bytestream, size)
  end
  defp delegate_reader(input_bytestream, :string, size) do
    Parser.Readers.DomString.read!(input_bytestream, size)
  end
  defp delegate_reader(input_bytestream, :section, module) do
    apply(module, :read!, input_bytestream)
  end

  defp read_key(source, :integer, key_size, val_type, val_spec,
                    acc_map\\%{}, acc_size\\0) do
    key = delegate_reader(source, :integer, key_size)
    case key do
      {0, :integer, _} -> {acc_map, :map, acc_size + key_size}
      {_, :integer, _} -> read_val(
        source, :integer, key_size, val_type,
        val_spec, acc_map, acc_size + key_size, key)
    end
  end

  defp read_val(source, key_type, key_size, val_type, val_spec,
                    acc_map, acc_size, last_key) do
    val = {_data, ^val_type, val_size} = delegate_reader(source, val_type, val_spec)
    read_key(source, key_type, key_size, val_type, val_size,
                 Map.put(acc_map, last_key, val), acc_size+val_size)
  end
end
