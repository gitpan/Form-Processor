package Form::Processor::Field::DateTimeManip;
use strict;
use warnings;
use base 'Form::Processor::Field';
use DateTime::Format::DateManip;

our $VERSION = '0.01';

my %date;


sub validate {
    my ( $self ) = @_;


    my $dt = DateTime::Format::DateManip->parse_datetime( $self->input );

    unless ( $dt ) {
        $self->add_error( "Sorry, don't understand date" );
        return;
    }

    # Manip sets the time zone to the local timezone (or what's globally set)
    # which means if the zone is later changed then the time will change.
    # So change it to a floating so if validation sets the timezone the
    # time won't change.
    # ** But fails if a timezone is specified on input **
    # so really need to parse at a later time.

    # $dt->set_time_zone( 'floating' );

    $self->value( $dt );

    1;
}

sub format_value {
    my $self = shift;

    return unless my $value = $self->value;
    die "Value is not a DateTime" unless $value->isa('DateTime');

    my $d = $value->strftime( '%a, %b %e %Y %l:%M %p %Z' );

    # The calendar javascript popup can't parse the day & hour with a leading space,
    # so remove.
    $d =~ s/\s(\s\d:)/$1/;
    $d =~ s/\s(\s\d\s\d{4})/$1/;


    return ($self->name => $d );

}





1;

