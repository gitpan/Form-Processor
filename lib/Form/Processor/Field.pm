package Form::Processor::Field;
use strict;
use warnings;
use base 'Rose::Object';
use Form::Processor::I18N;  # only needed if running without a form object.
use Scalar::Util;


our $VERSION = '0.01';


use Rose::Object::MakeMethods::Generic (
    scalar => [
        'name',         # Field's name
        'init_value',   # initial value populated by init_from_object - used to look for changes
                        # not to be confused with the form method init_value().
        'value',        # scalar internal value -- same as init_value at start.
        'input',        # input value from parameter
        'temp',         # Temporary storage for fields to save validated data
        'type',         # field type (e.g. 'Text', 'Select' ... )
        'label',        # Text label -- not really used much, yet.
        'style',        # Field's generic style to use for css formatting
        #'form',         # The parent form (defined below)
        'sub_form',     # The field is made up of a sub-form.
        # This is a more generic field type that can be used
        # in template to determine what type of html widget to generate
        widget      =>  { interface => 'get_set_init' },
        order       =>  { interface => 'get_set_init' },
    ],

    boolean => [
        'required',
        'password',
        'writeonly',    # Don't return this field in params.
        'clear',        # Don't validate and remove from database.

        # disabled and readonly mirror the html form specification
        # disabled fields are not suppose to be "successful" and thus
        # should not be updated.  But.. see "noupdate" below.
        'disabled',     # Don't update this field in the database.
        # readonly fields are basically like hidden fields that the UI
        # should no be able to modify but still are submitted.
        'readonly',     # Flag to indicate readonly field

        # Since disabled and readonly effect the UI differently
        # use a separate flag to tell the model to not update a field.
        'noupdate',     # don't update this field in the database
    ],

    array => [
        errors          => {},
        reset_errors    => { interface => 'reset', hash_key => 'errors' },
        add_error_str   => { interface => 'push',  hash_key => 'errors' },
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

This is a base class that allows basic functionality for form fields.
Form fields inherit from this class and thus may have additional methods.
See the documentation or source for the individual field.

You are encouraged to create specific fields for your application instead of
simply using the fields included with Form::Processor.


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

=item full_name

This returns the name of the field, but if the field
is a child field will prepend the field with the parent's field
name.  For example, if a field is "month" and the parent's field name
is "birthday" then this will return "birthday.month".

=cut

sub full_name {
    my $field = shift;

    my $name = $field->name;
    my $form = $field->form || return $name;
    my $parent = $form->parent_field || return $name;
    return $parent->name . '.' . $name;
}

=item form

This is a reference to the parent form object.
It's stored weakened references.

=cut

sub form {
    my $self = shift;
    return Scalar::Util::weaken( $self->{form} = shift ) if( @_ );
    return $self->{form};
}
=item sub_form

A single field can be represented by more than one sub-fields
contained in a form.  This is a reference to that form.


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

sub init_widget { 'text' }

=item order

This is the field's order used for sorting errors and field lists.

=cut

sub init_order { 1 }

=item set_order

This sets the field's order to the form's field_counter
and increments the counter.

The purpose of this is when displaying fields, say in a template,
this can be called with displaying the field to set its order.
Then a summary of error messages can be displayed in the order
the fields are on the form.

=cut

sub set_order {
    my $field = shift;
    my $form = $field->form;
    my $order = $form->field_counter || 1;
    $field->order( $order );
    $form->field_counter( $order + 1 );
}

=item value

Sets or returns the internal value of the field.

The "validate" field method must set this value if the field validates.

=item required

Sets or returns the required flag on the field

=item errors

returns the error (or list of errors if more than one was set)

=item add_error

Add an error to the list of errors.  If $field->form
is defined then process error message as Maketext input.
See $form->language_handle for details.

Returns undef.  This allows:

    return $field->add_error( 'bad data' ) if $bad;

=cut

sub add_error {
    my $self = shift;

    my $form = $self->form;

    my $lh;

    # By default errors get attached to the field where they happen.
    my $error_field = $self;

    # Running without a form object?
    if ( $form ) {
        $lh = $form->language_handle;

        # If we are a sub-form then redirect errors to the parent field
        $error_field = $form->parent_field if $form->parent_field;
    }
    else {
        $lh = $ENV{LANGUAGE_HANDLE} || Form::Processor::I18N->get_handle ||
            die "Failed call to Text::Maketext->get_handle";
    }

    $self->add_error_str( $lh->maketext( @_ ) );

    return;

}



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

    $field->validate;

If C<< $field->validate >> returns true then the input value
is copied from the input attribute to the field's value attribute
by calling:

    $field->input_to_value;

The default method simply copies the value.

The field's error list and internal value are reset upon entry.


=cut

sub validate_field {
    my $field = shift;


    $field->reset_errors;
    $field->value(undef);


    # See if anything was submitted
    unless ( $field->any_input ) {
        $field->add_error( $field->required_message )
            if $field->required;

        return !$field->required;
    }

    return unless $field->test_multiple;
    return unless $field->test_options;

    return unless $field->validate;


    # Now move data from input -> value
    $field->input_to_value;
}

=item validate

This method validates the input data for the field and returns true if
the data validates, false if otherwise.  It's expected that an error
message is added to the field if the field's input value does not validate.

The default method is to return true.

When overriding this method it is best to first call the parent class
validate method.  This way general to more specific error validation can occur.
For example in a field class:

    sub validate {
        my $field = shift;
        
        return unless $field->SUPER::validate;
        
        my $input = $field->input;
        #validate $input
        
        return $valid_input ? 1 : 0;
    }

If the validation method produces a final value in the process of validation
(e.g. creates a DateTime object from a string) then that value can either
be placed in C<< $field->value >> at that time and will not be copied by
C<< $field->input_to_value >>, or can place the value in a temporary location
and then the field can also override the C<input_to_value> method.


=cut

sub validate { 1 }

=item input_to_value

This method is called if C<< $field->validate >> returns true.
The default method simply copies the input attribute value to the
value attribute if C<< $field->value >> is undefined.

    $field->value( $field->input )
        unless defined $field->value;

A field's validation method can populate a field's value during
validation, or can override this method to populate the value after
validation has run.  Overriding this method is recommended.

=cut

sub input_to_value {
    my $field = shift;

    $field->value( $field->input )
        unless defined $field->value;
}



=item trim_value

Trims leading and trailing white space for single parameters.
If the parameter is an array ref then each value is trimmed.

Pass in the value to trim and returns value back

=cut

sub trim_value {
    my ($self, $value ) = @_;

    return unless defined $value;

    my @values = ref $value eq 'ARRAY' ? @$value : ( $value );

    for ( @values ) {
        next if ref $_;
        s/^\s+//;
        s/\s+$//;
    }

    return @values > 1 ? \@values : $values[0];
}

=item required_message

Returns text for use in "required" message.

=cut

sub required_message { 'This field is required' }

=item test_multiple

Returns false if the field is a multiple field
and the input for the field is a list.


=cut

sub test_multiple {
    my ( $self ) = @_;

    my $value = $self->input;

    if ( $self->can('options') &&  !$self->multiple && ref $value eq 'ARRAY' ) {
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

=item disabled
=item readonly

These allow you to give hints to how the html element is genrated.  This have specific
meanings in the HTML specification, but may not be consistently implemented.
Disabled controls should not be successful and thus not submitted in forms, where
readonly fileds can be.  Instead of depending on these field attribues, an
Form::Processor::Model classes should instead use the L<noupdate> flag
as an indicator if the field should be ignored or not.

=item clear

This is a flag that says you want to clear the database column for this
field.  Validation is also not run on this field.

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

