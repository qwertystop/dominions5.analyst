defmodule Parser do
  @type size :: pos_integer
  @type label :: :integer | :string | :bytes | :float | :list | :map | :section
  @type field :: {integer, :integer, size} | {binary, :string | :bytes, size} | {float, :float, size} | collection | section
  @type collection :: {[field], {:list, label}, size} | {%{required(integer) => field}, {:map, label}, size}
  @type section :: {[{atom, field}], :section, size}

  @callback read!(Enumerable.t) :: section
end
