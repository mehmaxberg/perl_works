package Local::Reducer::MinMaxAvg;

use base 'Local::Reducer';
use Scalar::Util qw(looks_like_number);
use strict;
use warnings;

sub reduce_n {
    my $self = shift;
    my $count = shift;
    my $returned_hash = {};
    my $count_avg = $count;
    my $field = $self->{field};

    $returned_hash->{max} = $self->{max};
    $returned_hash->{min} = $self->{min};
    
    while ($count > 0) {
        $count--;
        my $var = $self->{source}->next();
        return undef unless defined($var);
        my $temp_hash = $self->{row_class}->new(str => $var);
        if (looks_like_number($temp_hash->{$field})){
            if (!exists($self->{max}) || $temp_hash->{$field} > $self->{max}){
                $self->{max} = $temp_hash->{$field};
                $returned_hash->{max} = $temp_hash->{$field};
            }
            if (!exists($self->{min}) || $temp_hash->{$field} < $self->{min}){
                $self->{min} = $temp_hash->{$field};
                $returned_hash->{min} = $temp_hash->{$field};
            }
            $self->{sum} += $temp_hash->{$field};
        }
    }
    $returned_hash->{avg} = $self->{sum} / $self->{source}->{iterator};
    bless $returned_hash, __PACKAGE__;
}

sub get_max {
    my $self = shift;
    return $self->{max};
}

sub get_min {
    my $self = shift;
    return $self->{min};
}

sub get_avg {
    my $self = shift;
    return $self->{avg};
}

sub reduced {
    my $self = shift;
    return $self;
}

1;