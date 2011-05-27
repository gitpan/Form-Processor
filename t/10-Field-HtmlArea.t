use strict;
use warnings;

use lib './t';
use MyTest
    tests   => 5,
    recommended => [qw/ HTML::Tidy File::Temp /];



my $class = 'Form::Processor::Field::HtmlArea';
my $name = $1 if $class =~ /::([^:]+)$/;

# Mosty to test for bad nesting

my $good_html = <<'';
    <body>
    <p>This is nice
    and clean
    </p>
    <p><b>and bold</b></p>
    </body>

my $bad_html = <<'';
    <body>
    <p>This is nice
    and clean but not well formatted
    </p>
    <p><b>and bold without ending tag</p>
    </body>



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
    like( $field->errors->[0], qr!\QWarning: missing </b> before </p>!, 'Check tidy message' );


