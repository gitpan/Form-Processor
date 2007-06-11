use strict;
use warnings;
use Module::Find;
use Test::More;

my @fields = Module::Find::findsubmod Form::Processor::Field;

plan tests => @fields + 1;

use_ok( 'Form::Processor' );

use_ok( $_ ) for @fields;
