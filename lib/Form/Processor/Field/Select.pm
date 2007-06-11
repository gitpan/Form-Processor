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
        label_column    => { interface => 'get_set_init' },
        active_column   => { interface => 'get_set_init' },
        sort_order      => {},
    ],
);

sub init_widget { 'select' }

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
