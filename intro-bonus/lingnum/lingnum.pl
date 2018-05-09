#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
# error processing
die "\x1b[31m"."Sorry, but you must push only one integer number |i|<1000000000000\nFor example:
1) perl lingnum.pl 1\n2) perl lingnum.pl 127"."\x1b[0m"."\n" if ($ARGV[0] > 1000000000000) || ($ARGV[0] < -1000000000000) || (@ARGV != 1) || (!("".(0 + $ARGV[0]) eq $ARGV[0]) || !("".(0 + $ARGV[0]) eq int $ARGV[0]));

sub wordnum { # возвращает трехзначное число словами с учетом его степени
    my @firstline = qw(ноль один два три четыре пять шесть семь восемь девять десять одиннадцать двенадцать тринадцать четырнадцать пятнадцать шестнадцать семнадцать восемнадцать девятнадцать);
    my @secondline = qw(двадцать тридцать сорок пятьдесят шестьдесят семьдесят восемьдесят девяносто);
    my @thirdline = qw(сто двести триста четыреста пятьсот шестьсот семьсот восемьсот девятьсот);
    $firstline[0] = "";
    my $one = shift;
    my $second = shift;
    my $third = shift;
    my $fourth = shift;
    my $con = shift;
    my $k = shift; # число которое надо преобразовать
    my $lingnum = "";
    my $sublingnum = "";
    my $specificending = 1;
    if (($k % 10 == 1 || $k % 10 == 2 || $k % 10 == 3 || $k % 10 == 4) && int(($k % 100)/10) != 1) {$specificending = 0} # в этом случае словосочетание заканчивается специфически
    if ($k % 10 == 1 && int(($k % 100)/10) != 1) {$lingnum = $lingnum.$one} # запоминаем, если число заканчивается на один/однв тысяча/миллион/миллиард
    if ($k % 10 == 2 && int(($k % 100)/10) != 1) {$lingnum = $lingnum.$second} # -//- два/две тысячи/миллиона/миллиарда
    if ($k % 10 == 3 && int(($k % 100)/10) != 1) {$lingnum = $lingnum.$third} # -//- три -//-
    if ($k % 10 == 4 && int(($k % 100)/10) != 1) {$lingnum = $lingnum.$fourth} # -//- четыре -//-
    if (int ($k / 100) > 0 &&  $k % 100 == 0) {$lingnum = $thirdline[int($k/100) - 1].$con; return $firstline[$k].$lingnum;} # определяем первый номер в трехзначном числе
    # и если остальные номера нули сразу же его возвращаем
    if (int ($k / 100) > 0 ) {$sublingnum = $thirdline[int($k/100) - 1]." ";} # определяем первый номер в трехзначном числе
    $k = $k % 100;
    if (int ($k / 100) == 0 && $k >= 20 && $specificending) {$lingnum = $sublingnum.$secondline[int($k/10) - 2]." ".$firstline[$k % 10].$con} # определяем 2 и 3 номер в трехзначном числе
    if (int ($k / 100) == 0 && $k >= 20 && !($specificending)) {$lingnum = $sublingnum.$secondline[int($k/10) - 2]." ".$lingnum} # определяем 2 номер, учитывая специфичное окончание словасловосочетания
    if (int ($k / 100) == 0 && $k < 20 && $specificending) {$lingnum = $sublingnum.$lingnum.$firstline[$k].$con} # определяем 3 номер
    if (int ($k / 100) == 0 && $k < 20 && !($specificending)) {$lingnum = $sublingnum.$lingnum} # определяем 3 номер, учитывая специфическое окончание
    return $lingnum;
}
my $n = $ARGV[0];
my $ts = "";
if ($n < 0) {$ts = "минус "; $n = -$n}
if ($n == 0) {print "ноль\n"; exit}
my $l1 = $n % 1000;
my $l2 = int($n / 1000)%1000;
my $l3 = int($n / 1000000)%1000;
my $l4 = int($n / 1000000000);
my $line1 = wordnum("один", "два", "три", "четыре", " ", $l1);
my $line2 = wordnum("одна тысяча", "две тысячи", "три тысячи", "четыре тысячи", " тысячь", $l2); if ($l2 == 0) {$line2 = ""}
my $line3 = wordnum("один миллион", "два миллиона", "три миллиона", "четыре миллиона", " миллионов", $l3); if ($l3 == 0) {$line3 = ""}
my $line4 = wordnum("один миллиард", "два миллиарда", "три миллиарда", "четыре миллиарда", " миллиардов", $l4); if ($l4 == 0) {$line4 = ""}
print $ts.$line4." ".$line3." ".$line2." ".$line1."\n";
