#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you must push only one natural number\nFor example:
1) perl primes.pl 1\n2) perl primes.pl 127"."\x1b[0m"."\n" if (@ARGV != 1) || ($ARGV[0] < 1) || (!("".(0 + $ARGV[0]) eq $ARGV[0]) || !("".(0 + $ARGV[0]) eq int $ARGV[0]));

my $n = $ARGV[0];
my @sieve=(2..$n); #Eratosthenes sieve
my $p;

while(@sieve)
{
    while(@sieve && $sieve[0] == 0){shift @sieve;}
    last if !(@sieve);
    $p = shift @sieve;
    print $p."\n";
    for(my $i = $p-1; $i < @sieve; $i += $p){$sieve[$i] = 0;}
}
print "\n";
