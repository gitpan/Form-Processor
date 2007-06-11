package Form::Processor::Field::IntRange;
use strict;
use warnings;
use base 'Form::Processor::Field::Select';

use Rose::Object::MakeMethods::Generic (
    scalar => [
        range_start  => { interface => 'get_set_init' },
        range_end    => { interface => 'get_set_init' },
    ],
);

our $VERSION = '0.01';

sub init_options {
    my $self = shift;
    return [ map { { value => $_, label => $_ } } $self->range_start .. $self->range_end ];
}



1;
