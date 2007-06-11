package Form::Processor::Field::HtmlArea;
use strict;
use warnings;
use base 'Form::Processor::Field::TextArea';
use HTML::Tidy;
use File::Temp;

our $VERSION = '0.02';

my $tidy;

sub init_widget { 'textarea' }

sub validate {
    my $field = shift;
    return unless $field->SUPER::validate(@_);

    $tidy ||= $field->tidy;
    $tidy->clear_messages;


    # parse doesn't pass the config file in HTML::Tidy.
    $tidy->clean( $field->value );
    $field->add_error( $_->as_string ) for $tidy->messages;
    return;
}


# Parses config file.  Do it once.

my $tidy_config;
sub tidy {
    my $field = shift;
    $tidy_config ||= $field->init_tidy;
    my $t = HTML::Tidy->new( { config_file => $tidy_config } );


    $t->ignore( text => qr/DOCTYPE/ );
    $t->ignore( text => qr/missing 'title'/ );
    # $t->ignore( type => TIDY_WARNING );

    return $t;
}


sub init_tidy {

    my $tidy_conf = <<EOF;
char-encoding: utf8
input-encoding: utf8
output-xhtml: yes
logical-emphasis: yes
quiet: yes
show-body-only: yes
wrap: 45
EOF



    my $tidy_file = File::Temp->new( UNLINK => 1 );
    print $tidy_file $tidy_conf;
    close $tidy_file;

    return $tidy_file;


}

1;
