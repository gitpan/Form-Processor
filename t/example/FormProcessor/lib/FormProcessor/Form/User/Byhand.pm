package FormProcessor::Form::User::Byhand;
use strict;
use warnings;
use base 'Form::Processor';

sub profile {
    return {
        required => {
            first_name  => 'Text',
            last_name   => 'Text',
            email       => 'Email',
        },
    };
}




1;



