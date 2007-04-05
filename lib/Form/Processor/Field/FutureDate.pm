package Form::Processor::Field::FutureDate;
use strict;
use warnings;
use base 'Form::Processor::Field::DateTime';
use DateTime;

our $VERSION = '0.01';

my %date;

sub validate {
    my $field = shift;

    return unless $field->SUPER::validate( @_ );

    warn "Form::Processor::Field::FutureDate does not currently test future\n";

    return 1;

    return 1 unless $field->value_changed;

    return 1 if $field->value->clone->truncate( to => 'day' ) > DateTime->today;

    $field->add_error('This date must be in the future');

    return;

}


1;

