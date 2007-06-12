package Form::Processor::Field::Multiple;
use strict;
use warnings;
use base 'Form::Processor::Field::Select';

our $VERSION = '0.01';

=head1 DESCRIPTION 

This inherits from the Select field, which just provides options.
and sets the "multiple" flag true to accept multiple options.
If a field inherits from Select but you want to use it as a multiple
select then just define the file as such.

=cut


sub init_multiple { 1 } # allow multiple values.

sub init_size { 5 } # default to showing five items if showing in a select list.


=head1 METHODS

=head2 options

This options methods will re-arrange the opitions list to display
the currently selected items on top.

=cut

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


