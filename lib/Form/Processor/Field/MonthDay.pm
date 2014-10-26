package Form::Processor::Field::MonthDay;
{
  $Form::Processor::Field::MonthDay::VERSION = '1.122970';
}
use strict;
use warnings;
use base 'Form::Processor::Field::IntRange';



sub init_range_start {1}
sub init_range_end   {31}


# ABSTRACT: Select list for a day number 1 to 31




1;

__END__
=pod

=head1 NAME

Form::Processor::Field::MonthDay - Select list for a day number 1 to 31

=head1 VERSION

version 1.122970

=head1 SYNOPSIS

See L<Form::Processor>

=head1 DESCRIPTION

Generates a select list for integers 1 to 31.

=head2 Widget

Fields can be given a widget type that is used as a hint for
the code that renders the field.

This field's widget type is: "select".

=head2 Subclass

Fields may inherit from other fields.  This field
inherits from: "IntRange".

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

