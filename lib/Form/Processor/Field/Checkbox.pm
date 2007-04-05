package Form::Processor::Field::Checkbox;
use strict;
use warnings;
use base 'Form::Processor::Field';

our $VERSION = '0.01';

sub init_widget { 'Checkbox' }

# Single checkbox 
sub value {
    my $self = shift;

    my $v = $self->SUPER::value(@_);

    return defined $v && $v ? 1 : 0;
}





1;


