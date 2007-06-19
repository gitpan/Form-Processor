use strict;
use warnings;

use Test::More;
my $tests = 9;
plan tests => $tests;

my $class = 'Form::Processor::Field::Text';

my $name = $1 if $class =~ /::([^:]+)$/;

use_ok( $class );




my $field = $class->new(
    name    => 'test_field',
    type    => $name,
    form    => undef,
);



ok( defined $field,  'new() called' );

my $string = 'Some text';

$field->input( $string );
$field->validate_field;
ok( !$field->has_error, 'Test for errors 1' );
is( $field->value, $string, 'is value input string');

$field->input( '' );
$field->validate_field;
ok( !$field->has_error, 'Test for errors 2' );
is( $field->value, undef, 'is value input string');

$field->required(1);
$field->validate_field;
ok( $field->has_error, 'Test for errors 3' );

$field->input('hello');
$field->required(1);
$field->validate_field;
ok( !$field->has_error, 'Test for errors 3' );
is( $field->value, 'hello', 'Check again' );

