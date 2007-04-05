package Form::Processor::Field::Email;
use strict;
use warnings;
use base 'Form::Processor::Field';
use Email::Valid;

our $VERSION = '0.01';

sub validate {
    my $self = shift;

    $self->input( lc $self->{input} );


    unless ( Email::Valid->address( $self->input ) ) {
        $self->add_error('Email should be of the format someuser@example.com');
        return;
    }


    return $self->SUPER::validate;
}




1;

