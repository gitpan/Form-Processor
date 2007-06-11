package Form::Processor::Field::Readonly;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';

=item

This field is a display only field

=cut

sub readonly { 1 };  # for html rendering

sub noupdate { 1 }


our $VERSION = '0.01';




1;

