#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# календарь 2018 года
# error processing
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
if (@ARGV == 1) {
  die "\x1b[31m"."Sorry, but you can't push more than 1 argument\nFor example:\n1) perl cal.pl\n2) perl cal.pl 3"."\x1b[0m"."\n" if (@ARGV > 1) ;
  die "\x1b[31m"."Sorry, but your argument must be integer\nFor example:
1) perl cal.pl 5\n2) perl cal.pl 11"."\x1b[0m"."\n" if (!((0 + $ARGV[0]) eq $ARGV[0]) || !((0 + $ARGV[0]) eq int $ARGV[0])) && $ARGV[0] ne "";
  die "\x1b[31m"."Sorry, but your argument must be integer number from 1 to 12\nFor example:
1) perl cal.pl 5\n2) perl cal.pl 11"."\x1b[0m"."\n" if ($ARGV[0] < 1 || $ARGV[0] > 12) && $ARGV[0] ne "";
}

my @arrayofmonth = ("January","February","March","April","May","June","July","August","September","October","November","December");
my @daysofmonth = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31); # количество дней в месяце
my @displacementofmonth = (0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5); # с какого дня недели начинается месяц в 2018 году
my @arrayofdays = ("Mo","Tu","We","Th","Fr","Sa","Su");
my @grid = ("0" .. "8"); # массив, в который будет записан наш календарь
# первый день месяца = (отступ в месяце + отступ в годе(0 для 2018, т.к. начинается с понедельника))
my $tempday = $mday;
my $tempmon = $mon;
if (@ARGV == 1) {$mon = $ARGV[0] - 1; $mday = -1}
if (@ARGV == 1) {if ($ARGV[0] - 1 == $tempmon) {$mday = $tempday}}

# начинаем заполнять календарь
$grid[0] = $arrayofmonth[$mon];
$grid[1] = 2018;
@grid[2..8] = @arrayofdays;
for (my $i = 0; $i < $displacementofmonth[$mon]; $i++){push (@grid, " ")}
for (my $i = 1; $i < $daysofmonth[$mon] + 1; $i++){push (@grid, $i)}
# заканчиваем заполнять календарь

# выводим календарь
print "    ".$grid[0]." ";
print "\x1b[32m".$grid[1]."\x1b[0m"."\n";
for (my $i = 1; $i < @grid - 1; $i++) {
  if ($grid[$i+1] eq $mday) {
    printf "\x1b[1;31;42m%4.2s\x1b[0m", $grid[$i + 1];
  }
  elsif ($i > 7) {
    printf "\x1b[32m%4.2s\x1b[0m", $grid[$i + 1];
  }
  else {
    printf "%4.2s", $grid[$i + 1];
  }
  if ($i % 7 == 0) {print "\n"}
};
print "\n";
