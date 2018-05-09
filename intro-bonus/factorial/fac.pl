#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you must push only one natural number\nFor example:
1) perl fac.pl 1\n2) perl fac.pl 12"."\x1b[0m"."\n" if (@ARGV != 1) || ($ARGV[0] < 1) || (!("".(0 + $ARGV[0]) eq $ARGV[0]) || !("".(0 + $ARGV[0]) eq int $ARGV[0]));

my $n = $ARGV[0];

for (my $i = $n; $i > 1; $i--){
    $n = $n * ($i-1);
    if ($n == "inf") {print "Too great number\n"; exit;};
}
print $n."\n";
