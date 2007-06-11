package FormProcessor::Form::User::Compound;
use strict;
use warnings;
use base 'Form::Processor';

sub profile {
    return {
        required => {
            date    => 'DateTimeDMYHM',
            date2   => 'DateTimeDMYHM2',
        },
    };
}

1;

