package Form::Processor::Field::DateTimeDMYHM2;
use strict;
use warnings;
use base 'Form::Processor::Field';
use Form::Processor;
use DateTime;

# This implements a field made up of sub fields.

sub init_widget { 'Compound' }


our $VERSION = '0.01';

# This is to keep from reporting missing field
# for required fields.  Any missing data errors will propogate up.
sub any_input { 1 }

sub init {
    my $self = shift;

    $self->SUPER::init(@_);

    my $name = $self->name;

    my $required = $self->required ? 'required' : 'optional';

    $self->sub_form(
        Form::Processor->new(
            parent_field => $self,  # send all errors to parent field.
            profile => {
                optional=> {
                    day     => 'MonthDay',
                    month   => 'MonthName',
                    year    => 'Year',
                    hour    => 'Hour',
                    minute  => 'Minute',
                },
            },
        )
    );

    return;
}



sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    my $form = $self->sub_form;

    # First validate the sub fields, passing in the original parameters
    return unless $form->validate( scalar $self->form->params );

    my %date = map { $_ => $form->field($_)->value } qw/ day month year hour minute /;

    my $dt;
    eval {  $dt = DateTime->new( %date, time_zone => 'floating' ) };

    if ( $@ ) {
        my $error = $@;
        $error =~ s! at /.+$!!; # ! vim
        $self->add_error( "Invalid date [_1]", "$error" );
        return;
    }

    $self->temp( $dt );

    return 1;
}

sub input_to_value {
    my $field = shift;
    $field->value( $field->temp );
}

sub format_value {
    my $self = shift;


    my $name = $self->name;

    my %hash;

    my $dt = $self->value || return ();


    for my $sub ( qw/ month day year hour minute / ) {

        $hash{ $name . '.' . $sub } = $dt->$sub;
    }

    return %hash;
}


1;



