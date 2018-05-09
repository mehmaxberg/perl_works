#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
use Getopt::Long;
use Getopt::Long qw(:config no_ignore_case bundling);
use utf8;
binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

# colors:
my $BLUE = "\x1b[36m";
my $YELLOW = "\x1b[33m";
my $GREEN = "\x1b[32m";
my $RED = "\x1b[31m";
my $END = "\x1b[0m";

my $key = {
	A => 0, # печатать N строк после совпадения
	B => 0, # печать N строк до совпадения
	C => 0, # печать N строк вокруг совпадения
	c => 0, # количество строк
	i => 0, # игнорировать регистр
	v => 0, # исключать вместо совпадения
	F => 0, # точное совпадение со строкой
	n => 0, # печатать номер строки
};

GetOptions($key, qw/
	A=i
	B=i
	C=i
	c
	i
	v
	F
	n
/);

my $pattern = shift(@ARGV); 
if ($key->{i}) {$pattern = qr/$pattern/i;}
if ($key->{F}) {$pattern = quotemeta($pattern)}

sub print_string_num {
	my $i = shift;
	my $string = shift;
	if ($key->{v} == 0){
		$i++;
		if ($key->{n} && $string =~ m/$pattern/){
			print $BLUE.$i.$END.":";
		}
		if ($key->{n} && !($string =~ m/$pattern/)){
			print $BLUE.$i.$END."-";
		}
	}
	if ($key->{v} == 1){
		$i++;
		if ($key->{n} && $string =~ m/$pattern/){
			print $BLUE.$i.$END."-";
		}
		if ($key->{n} && !($string =~ m/$pattern/)){
			print $BLUE.$i.$END.":";
		}
	}
}

#die $RED."No pattern or wrong keys".$END unless defined($pattern);

$key->{B} = $key->{C} if $key->{B} < $key->{C};
$key->{A} = $key->{C} if $key->{A} < $key->{C};
my $B = $key->{B};
my $A = $key->{A};
my $flagA = 0;
my $i = 0;
my @B_arr;

while (<STDIN>) {
	my $string = $_;
	if ($key->{c} == 0 && $B > 0){
		push(@B_arr, $string);
		if (@B_arr > $B + 1){
			shift(@B_arr);
		}
	}
	if ($key->{v} == 0 && $key->{c} == 0 && $flagA && !($string =~ m/$pattern/)){
		print_string_num($i, $string);
		print $YELLOW.$string.$END;
		$flagA--;
		say "--" if ($flagA == 0);
	}
	if ($key->{v} == 1 && $key->{c} == 0 && $flagA && $string =~ m/$pattern/){
		print_string_num($i, $string);
		print $YELLOW.$string.$END;
		$flagA--;
		say "--" if ($flagA == 0);
	}
	if ($key->{v} == 0 && $string =~ m/$pattern/){
		if ($key->{A}) {$flagA = $key->{A}}
		if ($key->{c} == 0 && $key->{B}){
			say "--" if @B_arr > 1;
			for (my $k = 0; $k < @B_arr - 1; $k++){
				print_string_num($i - @B_arr + 1 + $k, $B_arr[$k]);
				print $YELLOW.$B_arr[$k].$END;
			}
			@B_arr = ();
		}
		if ($key->{c}){
			$key->{c}++;
			next;
		}
		print_string_num($i, $string);
		print $GREEN.$string.$END;
	} 
	if ($key->{v} == 1 && !($string =~ m/$pattern/)){
		if ($key->{A}) {$flagA = $key->{A}}
		if ($key->{c} == 0 && $key->{B}){
			say "--" if @B_arr > 1;
			for (my $k = 0; $k < @B_arr - 1; $k++){
				print_string_num($i - @B_arr + 1 + $k, $B_arr[$k]);
				print $YELLOW.$B_arr[$k].$END;
			}
			@B_arr = ();
		}
		if ($key->{c}){
			$key->{c}++;
			next;
		}
		print_string_num($i, $string);
		print $GREEN.$string.$END;
	}
	$i++;
}
if ($key->{c}){
	say $key->{c} - 1;
}