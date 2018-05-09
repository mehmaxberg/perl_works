package Local::Row::JSON;


use base 'Local::Row';
use JSON;
use strict;
use warnings;

sub parse {
    my $self = shift;
    my $str = shift;
    my $field = {};

    return undef unless defined($str);
    unless ($str =~ m/^\{/ || $str =~ m/\{$/){
        return undef;
    }
    eval {
        $field->{name} = decode_json $str;
    } or do {return undef;};
    if (defined($field->{name})){
        return $field->{name};
    } else {
        return undef;
    }
}

1;