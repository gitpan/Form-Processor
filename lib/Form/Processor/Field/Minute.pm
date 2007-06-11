package Form::Processor::Field::Minute;
use strict;
use warnings;
use base 'Form::Processor::Field::IntRange';

sub init_options {
    my $self = shift;
    return [
        map {
            { value => $_, label => sprintf( '%02d', $_)  }
        } $self->range_start .. $self->range_end
    ];
}


sub init_range_start { 0 }
sub init_range_end { 59 }


1;
