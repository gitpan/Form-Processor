package Form::Processor::Field::Checkbox;
use strict;
use warnings;
use base 'Form::Processor::Field';

our $VERSION = '0.01';

sub init_widget { 'checkbox' }

sub input_to_value {
    my $field = shift;

    $field->value( $field->input ? 1 : 0 );
}

sub value {
    my $field = shift;
    return $field->SUPER::value( @_ ) if @_;
    my $v = $field->SUPER::value;
    return defined $v ? $v : 0;
}

1;


