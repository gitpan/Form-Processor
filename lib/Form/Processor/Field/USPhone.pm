package Form::Processor::Field::USPhone;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;

    my $input = $self->input;

    $input =~ s/\D//g;

    unless ( length $input == 10 ) {
        $self->add_error('Phone Number must be 10 digits, including area code');
        return;
    }

    return $self->SUPER::validate;

}





1;

