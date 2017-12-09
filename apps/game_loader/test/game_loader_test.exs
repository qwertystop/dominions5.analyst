defmodule GameLoaderTest do
  use ExUnit.Case
  doctest GameLoader

  test "greets the world" do
    assert GameLoader.hello() == :world
  end
end
