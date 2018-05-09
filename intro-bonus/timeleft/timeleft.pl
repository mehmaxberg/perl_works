#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you can't push arguments\nFor example:\n1) perl timeleft.pl"."\x1b[0m"."\n" if @ARGV > 0 ;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
print localtime." \n";

my $lefthour = 3600 - $min * 60 - $sec;
my $leftday = 24*3600 - (3600 * $hour + $min * 60 + $sec);
my $leftweek = (6 - $wday) * 24 * 3600 - (3600 * $hour + $min * 60 + $sec);

print "hoursec = $lefthour \n";
print "daysec = $leftday \n";
print "weeksec = $leftweek \n";

