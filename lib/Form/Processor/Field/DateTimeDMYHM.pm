package Form::Processor::Field::DateTimeDMYHM;
use strict;
use warnings;
use base 'Form::Processor::Field';
use DateTime;

sub init_widget { 'Compound' }


our $VERSION = '0.01';


# override completely validate

sub validate {
    my ( $self ) = @_;

    my $params = $self->form->params;

    my $name = $self->name;

    my %date;

    my $found = 0;

    for my $sub ( qw/ month day year hour minute / ) {
        my $value = $params->{ $name . '.' . $sub };

        next unless defined $value;
        $found++;

        unless ( $value =~ /^\d+$/ ) {
            $self->add_error( "Invalid value for '$sub'" );
            return;
        }
        $date{ $sub } = $value;
    }

    # If any found, make sure all are entered
    if ( $self->required ) {
        unless ( $found ) {
            $self->add_error( "Date is required" );
            return;
        }
    }


    my $dt;
    eval {  $dt = DateTime->new( %date, time_zone => 'floating' ) };

    if ( $@ ) {
        $self->add_error( "Invalid date [$@]" );
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

