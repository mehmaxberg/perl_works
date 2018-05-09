package Local::Row::Simple;

use base 'Local::Row';
use JSON;
use strict;
use warnings;

sub parse {
    my $self = shift;
    my $str = shift;
    my $field = {};
 
    my @temp_array = split /,/, $str;
    if (@temp_array == 0){
        return {};
    }
    foreach my $var (@temp_array){
        if (index($var, ":") != rindex($var, ":") || index($var, ":") == -1){
            return undef;
        }
        my @duo_array = split /:/, $var;
        $field->{name}->{$duo_array[0]} = $duo_array[1];
    }
    if (defined($field->{name})){
        return $field->{name};
    } else {
        return undef;
    }
    
}

1;