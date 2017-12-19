defmodule DomMap do
  # simple case, will define others only if they prove necessary
  def read(io_bytestream, {:integer, key_size}, {:integer, val_size}) do
    read_key_int(io_bytestream, key_size, val_size)
  end

  defp read_key_int(source, key_size, val_size, acc_map=%{}\\%{}, acc_size\\0) do
    <<key::integer-little-size(key_size)>> = Enum.take(source, key_size)
    if key == 0 do
      {acc, :map, acc_size + key_size}
    else
      read_val_int(source, key_size, val_size, acc_map, acc_size + key_size, key)
    end
  end

  defp read_val_int(source, key_size, val_size, acc_map=%{}, acc_size, last_key) do
    <<val::integer-little-size(val_size)>> = Enum.take(source, val_size)
    read_key_int(source, key_size, val_size, Map.put(acc_map, last_key, val), acc_size+val_size)
  end
end
