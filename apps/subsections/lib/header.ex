defmodule Header do
  @moduledoc """
  Header of all Dom5 files
  """

  defstruct [
    :user_id, :game_version, :turn_number, :unk00, :unk01, 
    :realm_id, :unk02, :unk03, :game_name, :password,
    :master_password, :turn_key
  ]
  @type t :: %Header{
    user_id: integer(), game_version: integer(), turn_number: integer(),
    unk00: integer(), unk01: integer(), realm_id: integer(),
    unk02: integer(), unk03: integer(), game_name: binary(),
    password: binary(), master_password: binary(), turn_key: integer()
  }
  
  def unpack(<<0x01, 0x02, 0x04, 0x44, 0x4F, 0x4D, packed::binary>>) do
    # TODO
  end
