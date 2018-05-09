package Local::Reducer::Sum;

use base 'Local::Reducer';
use Scalar::Util qw(looks_like_number);
use strict;
use warnings;

sub reduce_n {
    my $self = shift;
    my $count = shift;
    my $field = $self->{field};
    while ($count > 0) {
        $count--;
        my $var = $self->{source}->next();
        return undef unless defined($var);
        my $temp_hash = $self->{row_class}->new(str => $var);
        if (looks_like_number($temp_hash->{$field})){
            $self->{reduced} += $temp_hash->{$field};
        }
    }
    return $self->{reduced};
}

1;