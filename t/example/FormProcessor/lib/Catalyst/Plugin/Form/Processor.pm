package Catalyst::Plugin::Form::Processor;
use strict;
use warnings;
use Carp;
use UNIVERSAL::require;
use NEXT;
use HTML::FillInForm;
use Module::Find;

our $VERSION = 0.01;

=head1 NAME

Catalyst::Plugin::Form::Processor - methods for processing forms with Form::Processor

=head1 SYNOPSIS

In the Catalyst application base class:

    use Catalyst qw/Form::Processor/;

Then in a controller:

    package App::Controller::User;
    use strict;
    use warnings;
    use base 'Catalyst::Controller';

    # Create or edit
    sub edit : Local {
        my ( $self, $c, $user_id ) = @_;

        # Validate and insert/update database
        reutrn unless $c->update_from_form( $user_id );

        # Form validated.

        $c->stash->{first_name} = $c->stash->{form}->value( 'first_name' );
    }

    # Form that doesn't update database
    sub profile : Local {
        my ( $self, $c ) = @_;

        # Redisplay form
        reutrn unless $c->validate_form;

        # Form validated.

        $c->stash->{first_name} = $c->stash->{form}->value( 'first_name' );
    }



=head1 DESCRIPTION

This plugin adds two methods to make using L<Form::Processer> easy to
use with Catalyst: C<<$c->form>> and C<<$c->update_from_form>>.

C<<$c->update_from_form>> calls C<<$c->form>> which loads the form
class based on the catalyst action name.  In the SYNOPSIS above
the two form modules C<App::Form::User::Edit> and C<App::Form::User::Update>
would be loaded.

The form object is stored in the stash as C<<$c->stash->{form}>>.  Templates
can use this to access for form.

In addition, this Plugin use HTML-FillInForm to populate the form.
Currently, only one form per page is supported.


=head1 METHODS

=head2 form ( $args_ref, $form_name );

    $form = $c->form;
    $form = $c->form( $user_id );
    $form = $c->form( $args_ref );
    $form = $c->form( $args_ref, $form_name );

Generates a form object, populates the stash "form" and returns the
form object.

The form will be require()ed at run time so the form does not need
to be specifically required.

But, it might be worth loading the modules at compile time if you
have a lot of modules to save on memory (e.g. under mod_perl).


Pass:
    $args_ref is an optional hash reference of arguments
    passed to the form's new method.

    If $form_name is not provided then will use the current controller
    class and the action for the form name.  If $form_name is defined then
    it is appended to C<$App::Form::>.  A plus sign can be included
    to avoid prefixing the form name.


    package MyApp::Controller::Foo::Bar
    sub edit : Local {

        # MyAPP::Form::Foo::Bar::Edit->new
        # Note the upper case -- ucfirst is used
        my $form = $c->form;

        # MyAPP::Form::Login::User->new
        my $form = $c->form( $args_ref, 'Login::User' );

        # External form Other::Form->new
        my $form = $c->form( $args_ref, '+Other::Form' );


Returns:
    Sets $c->{form} by calling new on the form object.
    That value is also returned.

=cut

sub form {
    my ( $c, $args_ref, $form_name ) = @_;

    my $package;
    if ( defined $form_name ) {

        $package
            = $form_name =~ s/^\+//
            ? $form_name
            : ref( $c ) . '::Form::' . $form_name;
    }
    else {
        $package = $c->action->class;
        $package =~ s/::C(?:ontroller)?::/::Form::/;
        $package .= '::' . ucfirst( $c->action->name );
    }

    $package->require
        or carp "Failed to load Form module $package";


    # Single argument to Form::Processor->new means it's an item id or object.
    # Hash references must be turned into lists.

    my @args = !ref $args_ref || Scalar::Util::blessed( $args_ref )
        ? $args_ref
        : %{$args_ref};


    return $c->stash->{form} = $package->new( @args );

} ## end sub form


=head2 validate_form

    return unless $c->validate_form;

This method passes the request paramters to 
the form's C<validate> method and returns true
if all fields validate.

This is the method to use if you are not using
a Form::Processor::Model class to automatically
update or insert a row into the database.

=cut

sub validate_form {
    my $c = shift;

    my $form = $c->form( @_ );

    return
        $c->form_posted
        && $form->validate( $c->req->parameters );

}



=head2 update_from_form

This combines common actions on CRUD tables.
It replaces, say:

    my $form = $c->form( $item );

    return unless $c->form_posted
        && $form->update_from_form( $c->req->parameters );

with

    $c->update_from_form( $item )

For this to work your form should inherit from a Form::Processor::Model
class (e.g. see L<Form::Processor::Model::CDBI>), or your form must
have an C<update_from_form()> method (which calls validate).

=cut

sub update_from_form {
    my $c = shift;

    my $form = $c->form( @_ );

    return
        $c->form_posted
        && $form->update_from_form( $c->req->parameters );

}

=head2 form_posted

This returns true if the request was a post request.
This could be replace with a method that does more extensive
checking, such as validating a form token to prevent double-posting
of forms.

=cut

sub form_posted {
    my $c = shift;

    return $c->req->method eq 'POST';
}

=head1 EXTENDED METHODS

=head2 dispatch

Automatically fills in a form if $form variable is found.
This can be disabled by setting

    $c->config->{form}{no_fillin};


=cut

# Used to override finailze, but that's not called in a redirect.
# TODO: add support for multiple forms on a page (and multiple forms
# in the stash).

sub dispatch {
    my $c = shift;

    my $ret = $c->NEXT::dispatch( @_ );


    return $ret if $c->config->{form}{no_fillin};

    my $params = $c->stash->{form}
        ? $c->stash->{form}->fif
        : '';

    return $ret unless
        $c->res->status == 200
        && $params && %{$params};

    # Run FillInForm
    $c->response->output(
        HTML::FillInForm->new->fill(
            scalarref => \$c->response->{body},
            fdat      => $params,
        ) );


    return $ret;

}

=head2 setup

If the C<pre_load_forms> will search for forms in the name space
provided by the C<form_name_space> configuration list or by default
the application name space with the suffix ::Form appended
(e.g. MyApp::Form).

=cut

sub setup {
    my $c = shift;
    $c->NEXT::setup( @_ );

    my $config = $c->config->{form} || {};

    return unless $config->{pre_load_forms};

    my $debug = $config->{debug};

    my $name_space = $c->config->{form_name_space} || $c->config->{name} . '::Form';
    my @namespace = ref $name_space eq 'ARRAY' ? @{ $name_space } : ( $name_space );


    for my $ns ( @namespace ) {
        warn "Searching for forms in the [$ns] namespace\n" if $debug;

        for my $form ( Module::Find::findallmod( $ns ) ) {

            warn "Loading form module [$form]\n" if $debug;

            $form->require or die "Failed to require form module [$form]";

            eval { $form->load_form };
            die "Failed load_module for form module [$form]: $@" if $@;
        }
    }

    return;
}



=head2 CONFIGURATION

Configuration is specified within C<<MyApp->config->{form}}>>.
The following options are available:

=over 4

=item no_fillin

Don't use use L<HTML::FillInForm> to populate the form data.

=item pre_load_forms

It this is true then will pre-load all modules in the MyApp::Form name space
during setup.
This works by requiring the form module and loading associated form fields.
The form is not initialized so any fields dynamically loaded may not be included.

This is useful in a persistent environments like mod_perl or FastCGI.

=item form_name_space

This is a list of name spaces where to look for forms to load.  It defaults to
the application name with the ::Form suffix (e.g. MyApp::Form).

=item debug

If true will write brief debugging information when running setup.

=back



=head1 AUTHOR

Bill Moseley

=head1 COPYRIGHT & LICENSE

Copyright 2007 Bill Moseley, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 See also

    L<Form::Processor>
    L<Form::Processor::Model::CDBI>

=cut

return 'oh, so true';







