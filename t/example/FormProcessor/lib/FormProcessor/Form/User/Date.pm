package FormProcessor::Form::User::Date;
use strict;
use warnings;
use base 'Form::Processor';

sub profile {
    return {
        required => {
            date        => 'DateTime',
            day     => 'MonthDay',
            month   => 'Month',
            mname   => 'MonthName',
            year    => 'Year',
            hour    => 'Hour',
            minute  => 'Minute',
            sec     => 'Second',
        },
    };
}





1;



