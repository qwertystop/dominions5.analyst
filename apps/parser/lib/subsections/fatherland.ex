defmodule Parser.Subsections.Fatherland do
  alias Parser.Subsections.{
    Commander,DelayedEvents,Dominion,EnchantmentData,EndStats,Header,
    Kingdom,Land,MercenaryData,Settings,SpellData,Unit}
  import Parser.Unpack
  use Parser.Unpack, [
    subsection(Header), subsection(Settings),
    map(:twoCalendars, {:integer, 4}, {:integer, 8}),
    unknown(:calendarSentry, 4),
    float(:zoom, 4),
    map(:lands, {:integer, 4}, {:subsection, Land}),
    map(:kingdoms, {:integer, 4}, {:subsection, Kingdom}),
    map(:commanders, {:integer, 4}, {:subsection, Commander}),
    map(:dominions, {:integer, 4}, {:subsection, Dominion}),
    map(:spells, {:integer, 4}, {:subsection, SpellData}),
    map(:mercenaries, {:integer, 4}, {:subsection, MercenaryData}),
    unknown(:mercUnknown, 100),
    map(:enchantments, {:integer, 4}, {:subsection, EnchantmentData}),
    # TODO incomplete
  ]
end
