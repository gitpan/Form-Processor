package Form::Processor::Field::DateTimeDMYHM2;
use strict;
use warnings;
use base 'Form::Processor::Field';
use DateTime;

# This implements a field made up of sub fields.

sub init_widget { 'Compound' }


use Rose::Object::MakeMethods::Generic (
    scalar => [
        sub_form => {},
    ],
);


our $VERSION = '0.01';

sub init {
    my $self = shift;

    $self->SUPER::init(@_);

    my $name = $self->name;

    $self->sub_form(
         Form::Processor::Field::DateTimeDMYHM2::Form->new( name_prefix => $name )
    );
}



sub validate {
    my $self = shift;

    my $form = $self->sub_form;

    # First validate the sub fields, passing in the original parameters
    return unless $sub_form->validate( $self->form->params );

    my %date = map { $_ => $form->field($_)->value } qw/ day month year hour minute /;

    my $dt;
    eval {  $dt = DateTime->new( %date, time_zone => 'floating' ) };

    if ( $@ ) {
        $self->add_error( "Invalid date [_1]", "$@" );
        return;
    }

    $self->value( $dt );

    1;
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


package Form::Processor::Field::DateTimeDMYHM2::Form;
use strict;
use warnings;
use base 'Form::Processor::Base';

sub profile {
    return {
        auto_required => [ qw/ day month year hour minute /],
    };
}

sub guess_field_type { 'Select' }

sub options_day { [ map { $_, $_ } 1..31 ] }
sub options_year { [ map { $_, $_ } 2000..2010 ] }
sub options_hour { [ map { $_, $_ } 1..23 ] }
sub options_minute { [ map { $_, $_ } 0..59 ] }

sub options_month { 
    my $self = shift;
    my $n = 1;
    my @m = qw/
        January Feburary March April May June July
        August September October November December
    /;
    return [ map { $n++, $_ } @m  ];
}



1;

