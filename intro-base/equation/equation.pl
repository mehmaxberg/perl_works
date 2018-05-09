#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you must push 3 arguments\nFor example:
1) perl equation.pl 1\n2) perl equation.pl 2 3 4"."\x1b[0m"."\n" if (@ARGV != 3);
die "\x1b[31m"."Sorry, but your first argument can't be 0\n"."\x1b[0m"."\n" if ($ARGV[0] == 0);
for (my $i = 0; $i < @ARGV; $i++){
    die "\x1b[31m"."Sorry, but your arguments must be real numbers\nFor example:
    1) perl equation.pl 5.3\n2) perl cal.pl 11 34.3 2.5"."\x1b[0m"."\n" if !("".(0 + $ARGV[$i]) eq $ARGV[$i]) && $ARGV[$i] ne "";
}

my ($a, $b, $c) = ($ARGV[0], $ARGV[1], $ARGV[2]);
my ($x1, $x2);
my $tempbool = 0; #если tempbool = 0, то решения есть
my $tempstr = ", "; #обращается в пустую строку, если только 1 корень
my $D = $b ** 2 - 4*$a*$c;

eval {
    $x1 = (-$b + sqrt($D))/(2*$a);
    $x2 = (-$b - sqrt($D))/(2*$a);
    1} or do { print "\x1b[31m"."Equation have not arguments in real number"."\x1b[0m"."\n"; $tempbool = 1 ; exit};

if ($x1 == $x2) {$x2 = ""; $tempstr = ""}
if ($tempbool == 0){
    print $x1.$tempstr.$x2."\n";
}

