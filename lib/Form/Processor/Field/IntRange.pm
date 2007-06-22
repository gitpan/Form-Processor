package Form::Processor::Field::IntRange;
use strict;
use warnings;
use base 'Form::Processor::Field::Select';


our $VERSION = '0.01';

sub init_range_start { 1 }
sub init_range_end { 10 }

sub init_options {
    my $self = shift;
    return [ map { { value => $_, label => $_ } } $self->range_start .. $self->range_end ];
}



1;
