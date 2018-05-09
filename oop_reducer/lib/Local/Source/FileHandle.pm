package Local::Source::FileHandle;

use base 'Local::Source';
use strict;
use warnings;

sub check {
    return "fh", "GLOB";
}

sub next {
    my $self = shift;
    my $file = $self->{fh};
    my $string = <$file>;
    chomp($string) if defined($string);
    $self->{iterator}++;
    return $string;
}

1;