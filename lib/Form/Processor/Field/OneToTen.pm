package Form::Processor::Field::OneToTen;
use strict;
use warnings;
use base 'Form::Processor::Field::PosInteger';


our $VERSION = '0.01';

=head1 NAME

Form::Processor::Field::OneToTen -- Field::Processor Field

=head1 DESCRIPTION

Value constrained to integers 1 to 10.
For use in surveys using ten radio selects.

=cut


sub init_widget { 'radio' }

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    my $value = $self->value;
    if ( $value < 1 || $value > 10 ) {
        $self->add_error('Please select a value from 1 to 10');
        return;
    }

    return 1;

}




1;

