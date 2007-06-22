package Form::Processor::Field::Text;
use strict;
use warnings;
use base 'Form::Processor::Field';
our $VERSION = '0.02';


use Rose::Object::MakeMethods::Generic (
    scalar => [
        size            => { interface => 'get_set_init' },
    ],
);

sub init_size { 0 }

sub init_widget { 'text' }

sub validate {
    my $field = shift;

    return unless $field->SUPER::validate;


    # return if no size is set
    my $size = $field->size || return 1;

    my $value = $field->input;

    return $field->add_error( 'Please limit to [quant,_1,character]. You submitted [_2]', $size, length $value )
        if length $value > $size;


    return 1;

}


1;

