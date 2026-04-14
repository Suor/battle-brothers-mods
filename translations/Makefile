MOD_NAME = hackflows_translations
TAG_NAME = trans
SOURCES = scripts hackflows_translations

include ../Makefile.common

check: test
	@set -e
	rosetta -qc hackflows_translations/champion_beasts.nut  ~/projects/bbm/3rdparty/champion_beasts
	rosetta -qc hackflows_translations/AC.nut ~/projects/bbm/3rdparty/AC
