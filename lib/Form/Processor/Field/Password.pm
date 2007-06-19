package Form::Processor::Field::Password;
use strict;
use warnings;
use base 'Form::Processor::Field::Text';
# use Data::Password ();

our $VERSION = '0.01';

sub init_widget { 'password' }

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->password(1);
}

sub validate {
    my $self = shift;

    return unless $self->SUPER::validate;

    my $value = $self->input;

    return $self->add_error( 'Passwords must not contain spaces' )
        if $value =~ /\s/;

    return $self->add_error( 'Passwords must be made up from letters, digits, or the underscore' )
        if $value =~ /\W/;

    #return $self->add_error( 'Passwords must include one or more digits' )
    #    unless $value =~ /\d/;

    return $self->add_error( 'Passwords must not be all digits' )
        if $value =~ /^\d+$/;


    return $self->add_error( 'Passwords need to be six or more characters' )
        if length $value < 6;


    # This is too strcit.
    # Need to make sure it doesn't match login
    # my $msg = Data::Password::IsBadPassword( $self->input );
    #return $self->SUPER::validate unless $msg;
    #$self->add_error( $msg );

    # So hack it.
    my $params = $self->form->params;

    for (qw/ login username / ) {
        next if $self->name eq $_;

        return $self->add_error( 'Password must not match ' . $_ )
        if $params->{$_} && $params->{$_} eq $value;
    }

    return 1;


}

sub required_message { 'Please enter a password in this field' }


1;

