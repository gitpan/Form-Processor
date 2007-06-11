package Form::Processor::Field::Month;
use strict;
use warnings;
use base 'Form::Processor::Field::IntRange';


sub init_range_start { 1 }
sub init_range_end { 12 }


1;
