defmodule OrderParserTest do
  use ExUnit.Case
  doctest OrderParser

  test "greets the world" do
    assert OrderParser.hello() == :world
  end
end
