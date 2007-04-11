use strict;
use warnings;

use Test::More;
plan tests => 7;

my $class = 'Form::Processor::Field::Email';
my $name = $1 if $class =~ /::([^:]+)$/;

SKIP:
{
    eval { require Email::Valid };
    skip( 'Skip: failed to load module Email::Valid', 7 ) if $@;


    use_ok( $class );
    my $field = $class->new(
        name    => 'test_field',
        type    => $name,
        form    => undef,
    );

    ok( defined $field,  'new() called' );

    $field->input( 'foo@bar.com' );
    $field->validate_field;
    ok( !$field->has_error, 'Test for errors 1' );
    is( $field->value, 'foo@bar.com', 'value returned' );

    $field->input( 'foo@bar' );
    $field->validate_field;
    ok( $field->has_error, 'Test for errors 1' );
    is( $field->errors->[0], 'Email should be of the format someuser@example.com', 'Test error message' );

    $field->input( 'someuser@example.com' );
    $field->validate_field;
    ok( !$field->has_error, 'Test for errors 2 although probably should fail' );


}

