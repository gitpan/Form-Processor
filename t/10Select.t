use strict;
use warnings;

use Test::More;
my $tests = 7;
plan tests => $tests;

my $class = 'Form::Processor::Field::Select';

my $name = $1 if $class =~ /::([^:]+)$/;

use_ok( $class );
my $field = $class->new(
    name    => 'test_field',
    type    => $name,
    form    => undef,
);

$field->options([
    { value => 1, label => 'one' },
    { value => 2, label => 'two' },
    { value => 3, label => 'three' },
]);

ok( defined $field,  'new() called' );

$field->input( 1 );
$field->validate_field;
ok( !$field->has_error, 'Test for errors 1' );
# Hum, should this be an array?
is( $field->value, 1, 'Test true == 1' );

$field->input( [1] );
$field->validate_field;
ok( $field->has_error, 'Test for errors array' );


$field->input( [1,4] );
$field->validate_field;
ok( $field->has_error, 'Test for errors 4' );
is( $field->errors->[0], 'This field does not take multiple values', 'Error message' );
