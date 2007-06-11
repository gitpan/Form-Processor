package Form::Processor::Field::Hour;
use strict;
use warnings;
use base 'Form::Processor::Field::Minute';


sub init_range_start { 0 }
sub init_range_end { 23 }


1;
