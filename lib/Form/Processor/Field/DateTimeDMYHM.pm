package Form::Processor::Field::DateTimeDMYHM;
{
  $Form::Processor::Field::DateTimeDMYHM::VERSION = '1.122970';
}
use strict;
use warnings;
use base 'Form::Processor::Field';
use DateTime;


sub init_widget {'Compound'}



# override completely validate

sub validate_field {
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
            $self->add_error( "Invalid value for '[_1]", $sub );
            return;
        }
        $date{$sub} = $value;
    }

    # If any found, make sure all are entered
    if ( $self->required ) {
        unless ( $found ) {
            $self->add_error( "Date is required" );
            return;
        }
    }


    my $dt;
    eval { $dt = DateTime->new( %date, time_zone => 'floating' ) };

    if ( $@ ) {
        my $error = $@;
        $error =~ s! at .+$/!!;

        # probably don't want to use that error message directly
        $self->add_error( "Invalid date ([_1])", "$error" );
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

        $hash{ $name . '.' . $sub } = sprintf( '%02d', $dt->$sub );
    }

    return %hash;
}



# ABSTRACT: DEPRECATED example of a compound field



1;


__END__
=pod

=head1 NAME

Form::Processor::Field::DateTimeDMYHM - DEPRECATED example of a compound field

=head1 VERSION

version 1.122970

=head1 SYNOPSIS

See L<Form::Processor>

=head1 DESCRIPTION

This is a compound field that uses modified field names for the 
sub fields instead of using a separate sub-form.

This is not well tested and should only be used after extensive testing.
It's more of an example than a real field.

=head2 Widget

Fields can be given a widget type that is used as a hint for
the code that renders the field.

This field's widget type is: "Compound".

=head2 Subclass

Fields may inherit from other fields.  This field
inherits from: "Field".

=head1 DEPENDENCIES

L<DateTime>

=head1 SUPPORT / WARRANTY

L<Form::Processor> is free software and is provided WITHOUT WARRANTY OF ANY KIND.
Users are expected to review software for fitness and usability.

=head1 AUTHOR

Bill Moseley <mods@hank.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Bill Moseley.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

