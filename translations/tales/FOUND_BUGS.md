# Hackflow's Translations — bugs found by the scenario tests

## TR1. "Buy/Sell price: N%" stays English when no price range follows — low, unconfirmed in play

- Test: `core::TR1: a price line without a range is translated too`.
- Observed: `"Buy price: [color=…]120[/color]%"` comes back untranslated; with a range after the
  `%` (`" vs [100-130]"`) it is translated.
- Cause: the patterns in `translations/hackflows_translations/settlement_prices_tooltip.nut` end in
  `<tail:line>`; Rosetta's `line` is `[^\n]*(?:\n|$)`, and Squirrel's regexp doesn't match an empty
  string at the end of input (`regexp(@"[^\n]*(?:\n|$)").search("abc", 3)` is null in the
  standalone `squirrel` too, so not an engine divergence). Whether the mod ever prints a price line
  without the range (its source is compiled `.cnut`) wasn't checked; if it does, that line stays English.
  A Rosetta-side fix (let a trailing `line` match empty) would cover every such pattern.
