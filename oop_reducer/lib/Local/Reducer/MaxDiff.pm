package Local::Reducer::MaxDiff;

use base "Local::Reducer";
use Scalar::Util qw(looks_like_number);
use strict;
use warnings;

sub reduce_n {
    my $self = shift;
    my $count = shift;
    my $field1 = $self->{top};
    my $field2 = $self->{bottom};
    while ($count > 0) {
        $count--;
        my $var = $self->{source}->next();
        return undef unless defined($var);
        my $temp_hash = $self->{row_class}->new(str => $var);
        if (looks_like_number($temp_hash->{$field1}) && looks_like_number($temp_hash->{$field2})){
            if (!exists($self->{reduced}) || $temp_hash->{$field1} - $temp_hash->{$field2} > $self->{reduced}){
                $self->{reduced} = $temp_hash->{$field1} - $temp_hash->{$field2};
            }
        }
    }
    return $self->{reduced};
}

1;