package Local::Source::Text;

use base 'Local::Source';
use strict;
use warnings;

sub check {
    return "text", "";
}

sub new {
    my $self = shift->SUPER::new(@_);
    my $delimiter = $self->{delimiter} // "\n";
    my @temp_arr = split /$delimiter/, $self->{text};
    $self->{text} = \@temp_arr;
    return $self;
}

1;