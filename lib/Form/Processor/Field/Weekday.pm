package Form::Processor::Field::Weekday;
use strict;
use warnings;
use base 'Form::Processor::Field::Select';


sub init_options {
    my $i = 0;
    my @days = qw/
        Sunday
        Monday
        Tuesday
        Wednesday
        Thursday
        Friday
        Saturday
    /;
    return [
        map {
            {   value => $i++, label => $_ }
        } @days
    ];
}



1;
