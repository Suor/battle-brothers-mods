#!/usr/bin/perl
use v5.14;
use strict;
use warnings;

use constant SCRIPTS => "/home/suor/_downloads/Battle\ Brothers\ mods/bbtmp2/scripts-base/";

my ($file, $thing) = @ARGV;
my ($cls, $func) = split /\./, $thing;

my $full_cls = &cut_func($file, "tmp/$thing.HERE.nut", $cls, $func);
say $full_cls;
&cut_vanilla(SCRIPTS . $full_cls . ".nut", "tmp/$thing.VANILLA.nut", $func);

`meld tmp/$thing.HERE.nut tmp/$thing.VANILLA.nut`;


sub cut_func() {
    my ($from, $to, $cls, $func) = @_;

    open(my $fh, '<', $from) or die "Could not open file '$from' $!";
    open(my $ftmp, '>', $to) or die "Could not open file '$to' $!";

    my ($in_class, $in_func, $prefix_cls, $prefix_func) = (0, 0, "NEVER", "NEVER");
    my $full_cls;
    while (<$fh>) {
        if (!$in_class && /hook\w+\("(.*$cls)"/) {
            $full_cls = $1;
            $in_class = 1;
            ($prefix_cls) = /^(\s*)/;
        }
        if ($in_class && !$in_func && /$func\s+=\s+function/) {
            $in_func = 1;
            ($prefix_func) = /^(\s*)/;
        }
        print $ftmp s/$prefix_func/\t/gr if $in_func;
        $in_func = 0 if $in_func && /^$prefix_func}/;
        last if $in_class && /^$prefix_cls}/;
    }

    close($ftmp);
    close($fh);
    return $full_cls;
}

sub cut_vanilla() {
    my ($from, $to, $func) = @_;

    open(my $fh, '<', $from) or die "Could not open file '$from' $!";
    open(my $ftmp, '>', $to) or die "Could not open file '$to' $!";

    my ($in_func, $prefix_func) = (0, "NEVER");
    while (<$fh>) {
        if (!$in_func && /function\s+$func\s*\(/) {
            $in_func = 1;
            ($prefix_func) = /^(\s*)/;
        }
        print $ftmp $_ if $in_func;
        $in_func = 0 if $in_func && /^$prefix_func}/;
    }

    close($ftmp);
    close($fh);
}
