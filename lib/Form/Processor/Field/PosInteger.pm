package Form::Processor::Field::PosInteger;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    # remove plus sign.
    my $value = $self->input;
    if ( $value =~ s/^\+// ) {
        $self->input( $value );
    }


    return $self->add_error('Value must be a positive integer')
        unless $self->input =~ /^\d+$/;

    return 1;

}




1;

