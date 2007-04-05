package Form::Processor::Field::Integer;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate {
    my $self = shift;


    # remove plus sign.
    my $value = $self->input;
    if ( $value =~ s/^\+// ) {
        $self->input( $value );
    }

    unless ( $self->input =~ /^-?\d+$/ ) {
        $self->add_error('Value must be a positive or negative integer');
        return;
    }

    return $self->SUPER::validate;
}




1;

