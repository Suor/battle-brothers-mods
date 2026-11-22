# Russian Main Menu Fix

The Russian translation of the game (Русификатор 2.94 by ZoG Forum Team) replaces the main menu page with its own copy, which lacks `addCrossMarketing()`. The game still calls it every time the main menu is shown, so the page throws a JavaScript error there. This mod adds an empty `addCrossMarketing()` when it is missing, and does nothing otherwise.


## Compatibility

Is safe to add and remove at any time. Changes nothing without the Russian translation or once it gets the function back.


## Install

Put a zip into `data` dir. Requires [ModernHooks][].


[ModernHooks]: https://www.nexusmods.com/battlebrothers/mods/685
