defmodule Header do
  @moduledoc """
  Header of all Dom5 files
  """

  defstruct [
    :user_id, :game_version, :turn_number, :unk00, :unk01,
    :realm_id, :unk02, :unk03, :game_name, :password,
    :master_password, :turn_key
  ]
  
  def unpack(io_bytestream) do
    with <<0x01, 0x02, 0x04, 0x44, 0x4f, 0x4d,
         user_id::integer-little-32,
         game_version::integer-little-32,
         turn_number::integer-little-32,
         unk00::integer-little-32,
         unk01::integer-little-32,
         unk02::integer-little-32,
         realm_id::integer-little-32,
         unk02::integer-little-32,
         unk03::integer-little-32>> <- Enum.take(io_bytestream, 42),
         game_name <- DomString.read(io_bytestream),
         # passwords are additionally ciphered, but I don't need them here anyway.
         password <- DomString.read(io_bytestream),
         master_password <- DomString.read(io_bytestream),
         <<turn_key::integer-little-32>> <- Enum.take(io_bytestream, 4),
      do: {:ok, %Header{
        user_id: user_id, game_version: game_version, turn_number: turn_number,
        unk00: unk00, unk01: unk01, realm_id: realm_id,
        unk02: unk02, unk03: unk03, game_name: game_name,
        password: password, master_password: master_password, turn_key: turn_key
      }}
  end
end
