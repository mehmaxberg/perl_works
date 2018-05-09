#!/usr/bin/env perl
package Local::Source;

use 5.016;
use strict;
use warnings;

sub new {
    my ($class) = shift;
    my $self = {@_};
    my ($field, $ref_field) = $class->check();
    unless (exists($self->{$field}) && ref($self->{$field}) eq $ref_field){
        die "Wrong data";
    }
    $self->{iterator} = 0;
    bless $self, $class;
}

sub next {
    my $self = shift;
    my ($field, $ref_field) = $self->check();
    my $arr_ref = $self->{$field};
    my $string = $arr_ref->[$self->{iterator}];
    $self->{iterator}++;
    return $string;
}

1;