#!/usr/bin/env perl

use 5.016;  # for say, given/when
use warnings;

# This code required for use of given/when
BEGIN {
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

our $VERSION = 1.0;

BEGIN {
	$|++;     # Enable autoflush on STDOUT
	$, = " "; # Separator for print x,y,z
	$" = " "; # Separator for print "@array";
}

use FindBin;
use Data::Dumper;
use lib "$FindBin::Bin/../lib";
use Anagram;

my @list = map {
	my @v = split /\s+/, $_;
	@v == 1 ? $v[0] : \@v;
} grep { chomp; /\S/ } <>;

my $result = Anagram::anagram(\@list);
say "$_: @{$result->{$_}}" for sort keys %$result;
