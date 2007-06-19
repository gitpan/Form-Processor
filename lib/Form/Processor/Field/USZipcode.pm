package Form::Processor::Field::USZipcode;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';


our $VERSION = '0.01';

sub validate { 
    my $self = shift;

    return unless $self->SUPER::validate;

    return $self->add_error('US Zip code must be 5 or 9 digits')
        unless $self->input =~ /^(\s*\d{5}(?:[-]\d{4})?\s*)$/;

    return 1;
}


1;

