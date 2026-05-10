MOD_NAME = hackflows_translations
TAG_NAME = trans
SOURCES = scripts hackflows_translations

include ../Makefile.common

check: test
	@set -e
	rosetta -qc hackflows_translations/champion_beasts.nut  ~/projects/bbm/3rdparty/champion_beasts
	rosetta -qc hackflows_translations/settlement_prices_tooltip.nut ~/projects/bbm/3rdparty/settlement_prices_tooltip
	rosetta -qc hackflows_translations/background_bonuses.nut ~/projects/bbm/3rdparty/BackgroundBonuses
	rosetta -qc hackflows_translations/swifter.nut ~/projects/bbm/3rdparty/swifter
	rosetta -qc hackflows_translations/backgrounds_reforged.nut ~/projects/bbm/3rdparty/mod_backgrounds_reforged_compatibility
	rosetta -qc hackflows_translations/prepare_for_battle.nut ~/projects/bbm/3rdparty/prepare_for_battle
	rosetta -qc hackflows_translations/shield_damage.nut ~/projects/bbm/3rdparty/shield_damage
