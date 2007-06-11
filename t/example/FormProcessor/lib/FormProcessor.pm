package FormProcessor;
use strict;
use warnings;
use Locale::Maketext;
use Catalyst::Runtime '5.70';

use Catalyst qw/
    Static::Simple
    Form::Processor
    I18N
/;

our $VERSION = '0.01';

# Configure the application. 
#
# Note that settings in FormProcessor.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'FormProcessor',
    'V::TT'  => {
        INCLUDE_PATH => [
            __PACKAGE__->path_to( 'root', 'templates' ),
        ],
        PRE_PROCESS     => 'config',
        WRAPPER         => 'wrapper',
    },
    form => {
        debug => 1,
        pre_load_forms => 1,
    },
);

# Start the application
__PACKAGE__->setup;


my %reported;
sub localize {
    my $c = shift;

    warn "Need to localize [@_]\n" unless $reported{ $_[0] }++;

    $c->SUPER::localize( @_ );
}




=head1 NAME

FormProcessor - Catalyst based application

=head1 SYNOPSIS

    script/formprocessor_server.pl

=head1 DESCRIPTION

Demo appliction for Form::Processor

=head1 SEE ALSO

L<FormProcessor::C::Root>, L<Catalyst>, L<Form::Processor>, L<Catalyst::Plugin::Form::Processor>

=head1 AUTHOR

Bill Moseley,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
