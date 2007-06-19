package Form::Processor::Field::USPhone;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    my $input = $self->input;

    $input =~ s/\D//g;

    return $self->add_error('Phone Number must be 10 digits, including area code')
        unless length $input == 10;

    return 1;
}





1;

