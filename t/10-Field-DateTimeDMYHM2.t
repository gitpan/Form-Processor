use strict;
use warnings;

use Test::More skip_all => 'On the todo list';
plan tests => 10;

SKIP:
{
    eval { require DateTimeFoo };
    skip("Skipped tests: failed to load DateTime", 10 ) if @_;

    my $class = 'Form::Processor::Field::DateTimeDMYHM2';

    my $name = $1 if $class =~ /::([^:]+)$/;

    use_ok( $class );

    my $field = $class->new(
        name    => 'test_field',
        type    => $name,
        form    => undef,
    );

    ok( defined $field,  'new() called' );

    skip( "This test is TODO", 1 );

}
