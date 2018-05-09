#!/usr/bin/env perl
package Local::Row;

use 5.016;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $str = $args{str};
    my $fields = $class->parse($str);
    if (defined($fields)){
        bless $fields, $class;
    } else {return undef} 
}

sub get {
    my ($self, $name, $default) = @_;
    return exists $self->{$name} ? $self->{$name} : $default;
}


1;