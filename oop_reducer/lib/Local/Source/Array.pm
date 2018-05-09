package Local::Source::Array;

use base 'Local::Source';
use strict;
use warnings;

sub check {
    return "array", "ARRAY";
}

1;