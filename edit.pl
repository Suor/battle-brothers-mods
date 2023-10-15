#!/usr/bin/perl
use v5.14;
use strict;
use warnings;

our $^I = ""; # inplace edit files

my $mod_prefix = "hackflows";

sub rename_things {
    my ($dir, $prefix) = @_;

    my @files = map { s~^$dir~~; s~\.nut$~~; $_ } glob "$dir*.nut";
    my @ids = map { s~^${prefix}_~~r } @files;
    my $ids_re = "(" . join("|", @ids) . ")";

    # our @ARGV = map { chomp; $_ } `find . -name \*.nut`;
    # while ( <ARGV> ) {
    #     s~\b(${prefix}_)$ids_re~$1${mod_prefix}_$2~g;
    #     s~"(${prefix}\.)$ids_re~"$1$mod_prefix\.$2~g;
    #     print;
    # }

    for (@files) {
        my $new = s/^(${prefix}_)$ids_re/$1${mod_prefix}_$2/r;
        say "Rename ", $_, " -> ", $new;
        rename "$dir$_.nut", $dir . $new . ".nut";
    }
}

rename_things "scripts/skills/perks/", "perk";
