package Form::Processor::Field::URL;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';

our $VERSION = '0.01';

sub validate {
    my $self = shift;

    my $url = $self->input;

    unless ( $url =~ m!^\w+://[^/\s]+/\S*$! ) {
        $self->add_error('Enter a plain url "e.g. http://google.com/"');
        return;
    }

    return $self->SUPER::validate;


}




1;

