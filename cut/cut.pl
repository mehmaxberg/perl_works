#!/usr/bin/env perl

use 5.016;
use warnings;
use strict;
use Getopt::Long;
use utf8;
binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

my $key = {
	f => '', # выбрать колонки
	d => "\t", # использовать другой разделитель
	s => 0, # только строки с разделителем
};

GetOptions($key, qw/
    f=s
    d=s
    s
/);

my $sep = quotemeta($key->{d});
my @field = split /,/, $key->{f};
my $field = {};
for my $var (@field){
    $field->{$var} = $var;
}
my @output;
while (<STDIN>){
    my $string = $_;
    chomp($string);
    if ($key->{f} && $key->{s} && !($string =~ m/$sep/)){
        next;
    }
    @output = split /$sep/, $string;
    if (@output == 1){
        say $string;
        next;
    }
    my $field_count = @field + 0;
    for (my $i = 0; $i < @output; $i++){
        my $words = $output[$i];
        if (exists($field->{$i+1}) && $field_count == 1){
            print $words;
        }
        if (exists($field->{$i+1}) && $field_count > 1){
            print $words, $key->{d};
            $field_count--;
        }
    }
    print "\n" if $key->{f} ne '';
    say "@output" if $key->{f} eq '';
}