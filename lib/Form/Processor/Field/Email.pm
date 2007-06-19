package Form::Processor::Field::Email;
use strict;
use warnings;
use base 'Form::Processor::Field';
use Email::Valid;

our $VERSION = '0.01';

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    $self->input( lc $self->{input} );


    return $self->add_error('Email should be of the format [_1]', 'someuser@example.com')
        unless Email::Valid->address( $self->input );


    return 1;
}


1;

