package Form::Processor::Field::Year;
use strict;
use warnings;
use base 'Form::Processor::Field::IntRange';


sub init_range_start {
    return (localtime)[5] + 1900 - 5;
}
sub init_range_end {
    return (localtime)[5] + 1900 + 10;
}


1;
