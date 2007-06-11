package Form::Processor::Field::Hidden;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';


sub init_widget { 'hidden' }

1;

