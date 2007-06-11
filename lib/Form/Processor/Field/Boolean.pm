package Form::Processor::Field::Boolean;
use strict;
use warnings;
use base 'Form::Processor::Field';

our $VERSION = '0.01';

sub init_widget { 'radio' }  # although not really used.


sub value {
    my $self = shift;

    my $v = $self->SUPER::value(@_);

    return unless defined $v;

    return $v ? 1 : 0;
}


1;


