defmodule Parser.Readers.DomMap do
  # simple case, will define others only if they prove necessary
  def read(input_bytestream, {key_type, key_size}, {val_type, val_size}) do
    read_key_int(input_bytestream, key_type, key_size, val_type, val_size)
  end

  defp delegate_reader(input_bytestream, :integer, size) do
    Parser.Readers.Integer.read(input_bytestream, size)
  end
  defp delegate_reader(input_bytestream, :string, size) do
    Parser.Readers.DomString.read(input_bytestream, size)
  end

  defp read_key_int(source, key_type, key_size, val_type, val_size, acc_map=%{}\\%{}, acc_size\\0) do
    key = delegate_reader(source, key_type, key_size)
    if key == 0 do
      {acc_map, :map, acc_size + key_size}
    else
      read_val_int(source, key_size, val_size, acc_map, acc_size + key_size, key)
    end
  end

  defp read_val_int(source, key_size, val_size, acc_map=%{}, acc_size, last_key) do
    val = delegate_reader(source, val_type, val_size)
    read_key_int(source, key_size, val_size, Map.put(acc_map, last_key, val), acc_size+val_size)
  end
end
