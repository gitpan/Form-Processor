package Form::Processor::Field::Select;
use strict;
use warnings;
use base 'Form::Processor::Field';

our $VERSION = '0.01';

use Rose::Object::MakeMethods::Generic (
    array => [
        # Array of hashes with value and label.
        options         => { interface=> 'get_set_init' },
        reset_options   => { interface => 'reset', hash_key => 'options' },
    ],
    scalar => [
        multiple        => { interface => 'get_set_init' },
        size            => { interface => 'get_set_init' },

        label_column    => { interface => 'get_set_init' },
        active_column   => { interface => 'get_set_init' },
        auto_widget_size=> { interface => 'get_set_init' },
        sort_order      => {},
    ],
);

=item options

This is an array of hashes for this field.
Each has must have a label and value keys.

=cut

sub init_options { [] };

sub init_widget { 'select' }

=item multiple

If true allows multiple input values

=cut

sub init_multiple { 0 }

=item auto_widget_size

This is a way to provide a hint as to when to automatically
select the widget to display for fields with a small number of options.
For example, this can be used to decided to display a radio select for
select lists smaller than the size specified.

See L<select_widget> below.

=cut

sub init_auto_widget_size { 0 }

=item select_widget

If the widget is 'select' for the field then will look if the field
also has a L<auto_widget_size>.  If the options list is less than or equal
to the L<auto_widget_size> then will return C<radio> if L<multiple> is false,
otherwise will return C<checkbox>.

=cut

sub select_widget {
    my $field = shift;

    my $size = $field->auto_widget_size;

    return $field->widget unless $field->widget eq 'select' && $size;

    my $options = $field->options || [];

    return 'select' if @$options > $size;

    return $field->multiple ? 'checkbox' : 'radio';
}



=item size

This can be used to store how many items should be offered in the UI
at a given time.

Defaults to 0.

=cut

sub init_size { 0 }


=item label_column

Sets or returns the name of the method to call on the foreign class
to fetch the text to use for the select list.

Refers to the method (or column) name to use in a related
object class for the label for select lists.

Defaults to "name"

=cut

sub init_label_column { 'name' }


=item active_column

Sets or returns the name of a boolean column that is used as a flag to indicate that
a row is active or not.  Rows that are not active are ignored.

The default is "active".

If this column exists on the class then the list of options will included only
rows that are marked "active".

The exception is any columns that are marked inactive, but are also part of the
input data will be included with brackets around the label.  This allows
updating records that might have data that is now considered inactive.

=cut

sub init_active_column { 'active' }


=item sort_order

Sets or returns the column used in the foreign class for sorting the
options labels.  Default is undefined.

If this column exists in the foreign table then labels returned will be sorted
by this column.

If not defined or the column is not found as a method on the foreign class then
the label_column is used as the sort condition.

=cut




=item as_label

Returns the value as the label.
Does a string compare, although probably always numeric.

=cut

sub as_label {
    my $field = shift;

    my $value = $field->value;
    return unless defined $value;

    for ( $field->options ) {
        return $_->{label} if $_->{value} eq $value;
    }

    return;
}


1;
