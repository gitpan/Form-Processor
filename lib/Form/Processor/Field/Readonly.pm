package Form::Processor::Field::Readonly;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';

=item

This field is a display only field

=cut


our $VERSION = '0.01';

sub init {
    my $self = shift;
    $self->noupdate(1);
    $self->SUPER::init(@_);
}



1;

