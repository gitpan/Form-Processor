package Form::Processor::Field::MonthName;
use strict;
use warnings;
use base 'Form::Processor::Field::Select';


sub init_options {
    my $i = 1;
    my @months = qw/
        January
        February
        March
        April
        May
        June
        July
        August
        September
        October
        November
        December
    /;
    return [
        map {
            {   value => $i++, label => $_ }
        } @months
    ];
}



1;
