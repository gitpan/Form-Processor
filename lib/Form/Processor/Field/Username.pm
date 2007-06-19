package Form::Processor::Field::Username;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    my $input = $self->input || '';

    return $self->add_error('Usernames must not contain spaces')
        if $input =~ /\s/;

    return $self->add_error('Usernames must be at least 4 characters long')
        if length $input < 4;

    return 1;
}




1;

