package Form::Processor::Field::Username;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;

    my $input = $self->input || '';

    if ( $input =~ /\s/ ) {
        $self->add_error('Usernames must not contain spaces');
        return;
    }

    if ( length $input < 4 ) {
        $self->add_error('Usernames must be at least 4 characters long');
        return;
    }


    return $self->SUPER::validate;
}




1;

