use strict;
use warnings;

use Test::More;
my $tests = 5;
plan tests => $tests;

my $class = 'Form::Processor::Field::HtmlArea';
my $name = $1 if $class =~ /::([^:]+)$/;

# Mosty to test for bad nesting

my $good_html = <<'';
    <p>This is nice
    and clean
    </p>
    <p><b>and bold</b></p>

my $bad_html = <<'';
    <p>This is nice
    and clean but not well formatted
    </p>
    <p><b>and bold without ending tag</p>


SKIP:
{
    eval { require HTML::Tidy };
    skip( 'Skip: failed to load module HTML::Tidy', $tests ) if $@;

    eval { require File::Temp };
    skip( 'Skip: failed to load module File::Temp', $tests ) if $@;


    use_ok( $class );
    my $field = $class->new(
        name    => 'test_field',
        type    => $name,
        form    => undef,
    );

    ok( defined $field,  'new() called' );

    $field->input( $good_html );
    $field->validate_field;
    ok( !$field->has_error, 'Test for errors 1' );


    $field->input(  $bad_html );
    $field->validate_field;
    ok( $field->has_error, 'Test for failure 2' );
    is( $field->errors->[0],' (4:8) Warning: missing </b> before </p>', 'Check tidy message' );

}

