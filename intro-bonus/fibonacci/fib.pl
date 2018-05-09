#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you must push only one natural number\nFor example:
1) perl fib.pl 1\n2) perl fib.pl 127"."\x1b[0m"."\n" if (@ARGV != 1) || ($ARGV[0] < 1) || (!("".(0 + $ARGV[0]) eq $ARGV[0]) || !("".(0 + $ARGV[0]) eq int $ARGV[0]));

my $n = $ARGV[0];
my $s = 0;
my $a = 1;
my $b = 0;
for (my $i = 0; $i < $n-1; $i++){
    $s = $b + $a;
    $b = $a;
    $a = $s;
    if ($s == "inf") {print "Too great number\n"; exit;};
}
print $s."\n";
