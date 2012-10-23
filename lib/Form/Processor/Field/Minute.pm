package Form::Processor::Field::Minute;
{
  $Form::Processor::Field::Minute::VERSION = '1.122970';
}
use strict;
use warnings;
use base 'Form::Processor::Field::IntRange';


sub init_range_start  {0}
sub init_range_end    {59}
sub init_label_format {'%02d'}    # How the base class will format the options

# ABSTRACT: input range from 0 to 60




1;

__END__
=pod

=head1 NAME

Form::Processor::Field::Minute - input range from 0 to 60

=head1 VERSION

version 1.122970

=head1 SYNOPSIS

See L<Form::Processor>

=head1 DESCRIPTION

Generate a select list for entering a minute value.

=head2 Widget

Fields can be given a widget type that is used as a hint for
the code that renders the field.

This field's widget type is: "select".

=head2 Subclass

Fields may inherit from other fields.  This field
inherits from: "IntRange"

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

