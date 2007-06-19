package Form::Processor::Field::URL;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';

our $VERSION = '0.01';

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    my $url = $self->input;

    return $self->add_error('Enter a plain url "e.g. http://google.com/"')
        unless $url =~ m{^\w+://[^/\s]+/\S*$}; 

    return 1;


}




1;

