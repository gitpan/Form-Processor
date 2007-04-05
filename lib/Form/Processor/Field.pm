package Form::Processor::Field;
use strict;
use warnings;
use base 'Rose::Object';


our $VERSION = '0.01';


use Rose::Object::MakeMethods::Generic (
    scalar => [
        'name',         # field name
        'init_value',   # initial value populated by init_from_object - used to look for changes
                        # not to be confused with the form method init_value().
        'value',        # scalar internal value -- same as init_value at start.
        'input',        # input value from parameter
        'type',         # field type (e.g. 'Text', 'Select' ... )
        'label',        # Text label -- not really used much, yet.
        'style',        # Field's generic style to use for css formatting
        'form',         # The parent form
        # This is a more generic field type that can be used
        # in template to determine what type of html widget to generate
        widget      =>  { interface => 'get_set_init' },
    ],

    boolean => [
        'required',
        'password',
        'noupdate',     # don't update this field in the database
        'writeonly',    # Don't return this field in params.
    ],

    array => [
        errors          => {},
        reset_errors    => { interface => 'reset', hash_key => 'errors' },
        add_error       => { interface => 'push',  hash_key => 'errors' },
    ],
);

## Should $value be overridden to only return a value if there are not
#  any errors?

=head1 NAME

Form::Processor::Field - Base class for Fields used with Form::Processor

=head1 SYNOPSIS

    # Used from another class
    use base 'Form::Processor::Field::Text';
    my $field = Form::Processor::Field::Text->new( name => $name );


=head1 DESCRIPTION

This is a base class that allows basic functionallity for form fields.


=head1 METHODS

=over 4

=item new

Creates new field.  Will accept

    name, value, required (and errors)

as parameters.  Only 'name' is required.

=cut

sub init {
    my $self = shift;

    $self->SUPER::init(@_);
    die "Need to supply name parameter"
        unless $self->name;
}

=item name

Sets or returns the name of the field.

=item id

Returns an id for the field, which is 

    $field->form->name . $field->id

=cut

sub id {
    my $field = shift;
    return $field->form->name . $field->name
}

=item init_widget

This is the generic type of widget that could be used
to generate, say, the HTML markup for the field.
It's similar to the field's type(), but less specific since fields
of different types often use the same widget type.

For example, a Text field would have both the type and widget values
of "Text", where an Integer field would have "Integer" for the type
value and "Text" as the widget value.

Normally you do not need to set this in a field class as it should pick
it up from the base field class used for the specific field.

The basic types are:

    Type        : Example fields
    ------------:-----------------------------------
    Text        : Text, Integer, Single field dates
    Checkbox    : Checkbox
    Radio       : Boolean (yes,no), OneToTen
    Select      : Select, Multiple
    Textarea    : HtmlArea
    Compound    : A field made up of other fields

Note that a Select could be a drop down list or a radio group,
and that might be determined in the template code based on how
many select options there are.

Multiple select fields, likewise, might be an option list or
a group of checkboxes.



=cut

sub init_widget { 'Text' }

=item value

Sets or returns the internal value of the field.

The "validate" field method must set this value if the field validates.

=item required

Sets or returns the required flag on the field

=item errors

returns the error (or list of errors if more than one was set)

=item add_error

Add an error to the list of errors

=item reest_errors

Resets the list of errors.  The validate method
clears the errors by default.

=item validate_field

This method does standard validation, which currently tests:

    required        -- if field is required and value exists

Then if a value exists:

    test_multiple   -- looks for multiple params passed in when not allowed
    test_options    -- tests if the params passed in are valid options

If all of those pass then the field's validate method is called

    $self->validate;

The field's error list and internal value are reset upon entry.


=cut

sub validate_field {
    my ($self ) = @_;


    $self->reset_errors;
    $self->value(undef);


    # See if anything was submitted
    unless ( $self->any_input ) {
        $self->add_error( $self->required_message )
            if $self->required;

        return !$self->required;
    }

    return unless $self->test_multiple;
    return unless $self->test_options;

    return $self->validate;
}

=item validate

This method is normally overridden in a field's class.  It does more specific
test like checking that that the field is of the correct format.

The default is to copy the input data to the internal value.

=cut

sub validate {
    my $field = shift;
    $field->value( $field->input );
    1;
}


=item trim_value

Trims leading and trailing white space for single parameters.
If the parameter is an array ref then each value is trimmed.

Pass in the value to trim and returns value back

=cut

sub trim_value {
    my ($self, $value ) = @_;

    return unless defined $value;

    my @values = ref $value ? @$value : ( $value );

    s/^\s+//, s/\s+$// for @values;

    return @values > 1 ? \@values : $values[0];
}

=item required_message

Returns text for use in "required" message.

=cut

sub required_message { 'This field is required' }

=item test_multiple

Returns false if $self->input is a reference (assuming it's
an array ref).  Subclasses that allow multiple values should override.

Returns true or false;

=cut

sub test_multiple {
    my ( $self ) = @_;

    my $value = $self->input;

    if ( ref $value eq 'ARRAY' ) {
        $self->add_error('This field does not take multiple values');
        return;
    }

    return 1;
}

=item any_input

Returns true if $self->input contains any non-blank input.


=cut

sub any_input {
    my ( $self ) = @_;


    my $found;

    my $value = $self->input;

    # check for one value as defined
    return grep { /\S/ } @$value
        if ref $value eq 'ARRAY';

    return defined $value && $value =~ /\S/;
}

=item test_options

If the field has an "options" method then the input value (or values
if an array ref) is tested to make sure they all are valid options.

Returns true or false

=cut

sub test_options {
    my ( $self ) = @_;

    return 1 unless $self->can('options');

    # create a lookup hash
    my %options = map { $_->{value} => 1 }  $self->options;

    my $input = $self->input;

    return 1 unless defined $input;  # nothing to check

    for my $value ( ref $input eq 'ARRAY' ? @$input : ($input) ) {
        unless ( $options{$value} ) {
            $self->add_error( "'$value' is not a valid value" );
            return;
        }
    }

    return 1;
}


=item format_value

This method takes $field->value and formats it into a hash
that is merged in to the final params hash.  It's purpose is to take the
internal value an create the key/value pairs.

By default it returns:

    ( $field->name, $field->value )

A Date field subclass might expaned the value into:

    my $name = $field->name;
    return (
        $name . 'd'  => $day,
        $name . 'm' => $month,
        $name . 'y' => $year,
    );

It's up to you to not use duplicate hash values.

You might want to override test_required() if you don't use a matching field name
(e.g. $name . 'd' instead of just $name).

=cut

sub format_value {
    my $self = shift;
    my $value = $self->value;
    return defined $value ? ( $self->name, $value ) : ();
}

=item noupdate

This boolean flag indicates a field that should not be updated.  Field's
flagged as noupdate are skipped when processing by the model.

This is usesful when a form contains extra fields that are not directly
written to the data store.

=item writeonly

Fields flagged as writeonly are not fetched from the model when $form->params
is called.  This means the field's formatted value will not be included
in the hash returned by $form->fif when first populating a form with
existing values.

An example might be a situation where a trigger is used to create a copy of a
row before an update.  In this case you might have a required "update_reason"
column that should only be written to the database on updates.

Unlike the C<password> flag, this only prevents populating a field from the
field's initial value, but not from the parameter hash passed to the form.
Redrawn forms (after validation failures) will display the value submitted
in the form.


=item password

This is a boolean flag and if set the $form->params method will remove that
field when calling $form->fif.

This is different than the C<writeonly> method above in that the value is
removed from the hash every time its fetched.

=item value_changed

Returns true if the value in the item has changed from what is currently in the
field's value.

This only does a string compare (arrays are sorted and joined).

=cut

sub value_changed {
    my ( $self ) = @_;

    my @cmp;

    for ( qw/ init_value value / ) {
        my $val = $self->$_;
        $val = '' unless defined $val;

        push @cmp, join '|', 
            sort
                map {
                        ref($_) && $_->isa('DateTime') 
                            ? $_->iso8601 
                            : "$_"
                } ref($val) eq 'ARRAY' ? @$val : $val;

    }

    return $cmp[0] ne $cmp[1];
}

=item required_text

Returns "required" or "optional" based on the field's setting.

=cut

sub required_text { shift->required ? 'required' : 'optional' }

=item has_error

Returns the count of errors on the field.

=cut

sub has_error {
    my $self = shift;
    my $errors = $self->errors;
    return unless $errors;
    return scalar @$errors;
}




=item dump_field

A little debugging.

=cut

sub dump {
    my $f = shift;
    require Data::Dumper;
    warn "\n---------- [ ", $f->name, " ] ---------------\n";
    warn "Field Type: ", ref($f),"\n";
    warn "Required: ", ($f->required || '0'),"\n";
    warn "Password: ", ($f->password || '0'),"\n";
    my $v = $f->value;
    warn "Value: ", Data::Dumper::Dumper $v;
    my $iv = $f->init_value;
    warn "InitValue: ", Data::Dumper::Dumper $iv;
    my $i = $f->input;
    warn "Input: ", Data::Dumper::Dumper $i;
    if ( $f->can('options') ) {
        my $o = $f->options;
        warn "Options: ". Data::Dumper::Dumper $o;
    }
}




=back

=head1 AUTHOR

Bill Moseley - with *much* help from John Siracusa.  Most of this
is based on Rose-HTML-Form.  It's basically a very trimmed down version without
all the HTML generation and the ability to do compound fields.

=cut


1;

