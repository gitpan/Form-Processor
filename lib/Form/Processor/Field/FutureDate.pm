package Form::Processor::Field::FutureDate;
{
  $Form::Processor::Field::FutureDate::VERSION = '1.122970';
}
use strict;
use warnings;
use base 'Form::Processor::Field::DateTime';
use DateTime;



my %date;

sub validate_value {
    my $field = shift;

    return unless $field->SUPER::validate_value;

    warn "Form::Processor::Field::FutureDate does not currently test future\n";

    return 1;

    return 1 unless $field->value_changed;

    return 1 if $field->value->clone->truncate( to => 'day' ) > DateTime->today;

    return $field->add_error( 'This date must be in the future' );

}


# ABSTRACT: DEPRECATED tests that the entered date is in the future



1;


__END__
=pod

=head1 NAME

Form::Processor::Field::FutureDate - DEPRECATED tests that the entered date is in the future

=head1 VERSION

version 1.122970

=head1 SYNOPSIS

See L<Form::Processor>

=head1 DESCRIPTION

This inherits from the DateTime field and simply tests that the date is
a day in the future.

=head2 Widget

Fields can be given a widget type that is used as a hint for
the code that renders the field.

This field's widget type is: "text".

=head2 Subclass

Fields may inherit from other fields.  This field
inherits from: "DateTime".

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

