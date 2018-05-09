#!/usr/bin/env perl
package Local::Reducer;

use 5.016;
use strict;
use warnings;
use Scalar::Util;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
    my ($class) = shift;
    my $self = {@_};
    $self->{reduced} = 0;
    bless $self, $class;
}

sub reduced {
    my $self = shift;
    return $self->{reduced};

}

sub reduce_all {
    my $self = shift;
    my $result = 0;
    my $temp_result = 0;
    
    while (defined($temp_result)){
        $result = $temp_result;
        $temp_result = $self->reduce_n(1);
    }
    return $result;
}

1;
