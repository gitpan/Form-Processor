package Form::Processor::Field::Multiple;
use strict;
use warnings;
use base 'Form::Processor::Field::Select';

our $VERSION = '0.01';


sub test_multiple { 1 } # allow multiple values.


sub options {
    my $self = shift;
    my @options = $self->SUPER::options( @_ );
    my $value = $self->value;


    # This places the currently selected options at the top of the list
    # Makes the drop down lists a bit nicer

    if ( @options && defined $value ) {
        my %selected = map { $_ => 1 } ref($value) eq 'ARRAY' ? @$value : ($value);

        my @out =  grep {   $selected{ $_->{value} }  } @options;
        push @out, grep {  !$selected{ $_->{value} }  } @options;

        return wantarray ? @out : \@out;
    }

    return wantarray ? @options : \@options;
}

1;


