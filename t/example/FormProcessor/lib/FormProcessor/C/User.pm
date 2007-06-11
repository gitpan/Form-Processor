package FormProcessor::C::User;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Data::Dumper;


=head1 NAME

FormProcessor::C::User - Controller to demo Form::Processor

=head1 DESCRIPTION

Demonstration Application for Form::Processor.
This is an example of using Form::Processor in a Catalyst
controller.

=head1 METHODS

=cut

=head2 edit

=cut

sub edit : Local {
    my ( $self, $c ) = @_;
    $c->forward( 'form' );
}

=head2 byhand

=cut

sub byhand : Local {
    my ( $self, $c ) = @_;
    $c->forward( 'form' );
}


=head2 date

=cut

sub date : Local {
    my ( $self, $c ) = @_;
    $c->forward( 'form' );
}

=head2 compound

=cut

sub compound : Local {
    my ( $self, $c ) = @_;
    $c->forward( 'form' );
}

=head2 form

Same action for each method.

=cut


sub form : Private {
    my ( $self, $c ) = @_;

    return unless $c->validate_form( {
        init_object => {
            first_name  => 'John',
            last_name   => 'Doe',
            color       => 3,
            date        =>  DateTime->now,
            date2       =>  DateTime->now->subtract( months => 1 ),
        },
    });

    # Form validated.

    my $form = $c->stash->{form};

    for my $field ( $form->fields ) {
        warn sprintf( "Field [%s] input data [%s] with output data [%s]\n",
            $field->name, $field->input, $field->value )
            if $field->value;
    }


    $c->stash->{message} = 'Updated!';
}

=head1 AUTHOR

Bill Moseley,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
