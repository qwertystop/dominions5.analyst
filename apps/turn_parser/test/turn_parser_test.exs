defmodule TurnParserTest do
  use ExUnit.Case
  doctest TurnParser

  test "greets the world" do
    assert TurnParser.hello() == :world
  end
end
