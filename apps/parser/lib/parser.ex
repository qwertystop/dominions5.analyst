defmodule Parser do
  @type size :: pos_integer
  @type label :: :integer | :string | :bytes | :float | :list | :map
  @type field :: {integer, :integer, size} | {binary, :string | :bytes, size} | {float, :float, size} | collection
  @type collection :: {[field], {:list, label}, size} | {%{required(integer) => field}, {:map, label}, size}

  @callback read!(Enumerable.t) :: field
end
