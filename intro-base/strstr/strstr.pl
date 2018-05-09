#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you must push 2 arguments\nFor example:
1) perl strstr.pl \"nicestr\" \"str\"\n2) perl strstr.pl \"12345\" \"34\""."\x1b[0m"."\n" if (@ARGV != 2);

my $index;
eval {
    $index = index ($ARGV[0], $ARGV[1]);
};
if ($index == -1) {
    warn "Sorry, string not found";
    exit;
};
$ARGV[0] = $ARGV[0]."";
my $endstr = rindex($ARGV[0], "");

print $index."\n";
print substr($ARGV[0], $index, $endstr)."\n";

