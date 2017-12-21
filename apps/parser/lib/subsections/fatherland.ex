defmodule Parser.Subsections.Fatherland do
  @behaviour Parser
  alias Parser.Readers.{Bytes,DomMap,DomFloat}
  alias Parser.Subsections.{Header,Settings,Land,Kingdom,Commander,Dominion,SpellData,MercenaryData,EnchantmentData}
  def read!(input) do
    # This first chunk is simple enough to inline
    parsed = [
      header: Header.read!(input),
      settings: Settings.read!(input),
      # two interleaved maps
      calendars: DomMap.read!(input, {:integer, 4}, {:integer, 8}),
      cal_sentry: Bytes.read!(input, 4),
      zoom: DomFloat.read!(input, 4),
      # TODO maps with subsections for values
      lands: DomMap.read!({:integer, 4}, {:section, Land}),
      kingdoms: DomMap.read!({:integer, 4}, {:section, Kingdom}),
      commanders: DomMap.read!({:integer, 4}, {:section, Commander}),
      dominions: DomMap.read!({:integer, 4}, {:section, Dominion}),
      spells: DomMap.read!({:integer, 4}, {:section, SpellData}),
      mercenaries: DomMap.read!({:integer, 4}, {:section, MercenaryData}),
      merc_unknown: Bytes.read!(input, 100),
      enchantments: DomMap.read!({:integer, 4}, {:section, EnchantmentData})
    ]
    # After that it gets more complex
    # scores is based on contents of Settings
    scores = nil # TODO scores
    items = Bytes.read!(input, 1000)
    war_data = Bytes.read!(input, 40000)
    # heroes is a list of int16, length specified by int32
    # TODO improve abstraction on array of non-single-byte reading
    <<hero_count::integer-little-32>> = Enum.take(input, 4)
    heroes = Bytes.read!(input, (hero_count + 1) * 2)
    unkRXN = DomString.read!(input, length: 50, mask: 0x78) 
    end_stats = EndStats.read!(input)
    # sentinel should be exactly 4475, and then a count
    <<4475::integer-little-32, event_ct::integer-little-32>> = Enum.take(input, 8)
    # Events is another list of int16
    events = Bytes.read!(input, event_ct * 2)
    # DelayedEvents has another sentinel
    <<4480::integer-little-32>> = Enum.take(input, 4)
    delayed_events = DelayedEvents.read!(input)
    # closing sentinel on fatherland
    <<12346::integer-little-32>> = Enum.take(input, 4)
    # put it all in one list
    parsed = parsed ++ [
      scores: scores, items: items, war_data: war_data, heroes: heroes,
      unkRXN: unkRXN, end_stats: end_stats, events: events,
      delayed_events: delayed_events,
    ]

    {parsed, :section,
      Enum.reduce(parsed, 0, fn {_, _, size}, acc -> acc + size end)}
  end
end
