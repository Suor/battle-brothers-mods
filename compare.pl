#!/usr/bin/perl
use v5.14;
use strict;
use warnings;
use File::Temp qw/ tempdir /;

use constant SCRIPTS => "/home/suor/_downloads/Battle\ Brothers\ mods/bbtmp2/scripts-base/";

my ($file, $thing) = @ARGV;
my ($cls, $func) = split /\./, $thing;

my $tmp = tempdir("bb_compare_XXXX", CLEANUP => 1, TMPDIR => 1);
my ($full_cls, $funcs) = &cut_func($file, "$tmp/$thing.HERE.nut", $cls, $func);
say $full_cls;
&cut_vanilla(SCRIPTS . $full_cls . ".nut", "$tmp/$thing.VANILLA.nut", $funcs);

`meld $tmp/$thing.HERE.nut $tmp/$thing.VANILLA.nut`;


sub cut_func() {
    my ($from, $to, $cls, $func) = @_;
    $func //= "\\w+";

    open(my $fh, '<', $from) or die "Could not open file '$from' $!";
    open(my $ftmp, '>', $to) or die "Could not open file '$to' $!";

    my ($in_class, $in_func, $prefix_cls, $prefix_func) = (0, 0, "NEVER", "NEVER");
    my ($full_cls, @funcs);
    while (<$fh>) {
        if (!$in_class && /hook\w+\("(.*$cls)"/) {
            $full_cls = $1;
            $in_class = 1;
            ($prefix_cls) = /^(\s*)/;
        }
        if ($in_class && !$in_func && /\.($func)\s+=\s+function/) {
            push @funcs, $1;
            $in_func = 1;
            ($prefix_func) = /^(\s*)/;
        }
        print $ftmp s/$prefix_func/\t/gr if $in_func;
        $in_func = 0 if $in_func && /^$prefix_func}/;
        last if $in_class && /^$prefix_cls}/;
    }

    close($ftmp);
    close($fh);
    return $full_cls, \@funcs;
}

sub cut_vanilla() {
    my ($from, $to, $funcs) = @_;

    open(my $fh, '<', $from) or die "Could not open file '$from' $!";

    my ($prefix_func) = (0, "NEVER");
    my ($func, %texts);
    while (<$fh>) {
        if (!$func && /function\s+(\w+)\s*\(/) {
            $func = $1;
            $texts{$func} = "";
            ($prefix_func) = /^(\s*)/;
        }
        $texts{$func} .= $_ if $func;
        $func = "" if $func && /^$prefix_func}/;
    }
    close($fh);

    open(my $ftmp, '>', $to) or die "Could not open file '$to' $!";
    foreach my $func (@$funcs) {
        print $ftmp $texts{$func};
    }
    close($ftmp);
}
