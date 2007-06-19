package Form::Processor::Field::Money;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    # remove plus sign.
    my $value = $self->input;

    return unless defined $value;

    if ( $value =~ s/^\$// ) {
        $self->input( $value );
    }

    return $self->add_error('Value must be a real number')
        unless $value =~ /^-?\d+\.?\d*$/;


    $self->input( sprintf( '%2.2f', $value ) ) if defined $value;

    return 1;


}




1;

