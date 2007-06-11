package FormProcessor::C::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';
use IO::File;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

FormProcessor::C::Root - Root Controller for FormProcessor

=head1 DESCRIPTION

Demonstration Application for Form::Processor

=head1 METHODS


=head2 auto

=cut

sub auto : Private {
    my ( $self, $c, $show ) = @_;


    # This is hack to keep single element arrays from being scalars in TT
    $c->stash->{as_list} = sub { return ref( $_[0] ) eq 'ARRAY' ? shift : [shift] };

    return 1 unless $show;

    if ( $show eq 'template' ) {
        my $path = $c->path_to( 'root', 'templates', $c->action . '.tt' );
        $c->res->body( IO::File->new( $path ) );
        $c->res->content_type( 'text/plain' );
        return 0;
    }

    if ( $show eq 'form' ) {
        my @actions = map { ucfirst } split m!/!, $c->action;
        my $path = $c->path_to( 'lib', 'FormProcessor', 'Form', @actions );
        $path = $path . '.pm';
        $c->res->body( IO::File->new( $path ) );
        $c->res->content_type( 'text/plain' );
        return 0;
    }


    return 1;
}

=head2 default

=cut

sub default : Private {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'menu.tt';
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Bill Moseley,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
