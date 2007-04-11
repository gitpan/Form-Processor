package Form::Processor::Field::Template;
use strict;
use warnings;

# This doesn't work because need to transform the input data before can validate
# and the Form module doesn't support this.
# Also, not all template snippets are valid HTML
# Since it doesn't work then can simply use Template::Parser to validate
# the templates.

# use base 'Form::Processor::Field::HtmlArea';


use base 'Form::Processor::Field::TextArea';
# use HTML::Tidy;
use Template::Parser;

our $VERSION = '0.02';

# Checks that the template compiles and validates.


sub validate {
    my $field = shift;
    return unless $field->SUPER::validate(@_);

    my $parser = Template::Parser->new;

    unless ( $parser->parse( $field->value) ) {
        $field->add_error( 'Template Error: [_1]', $parser->error );
        return;
    }

}




1;


__END__

# Another approach, that doesn't quite work.


package Form::Processor::Field::HtmlArea::Provider;
use strict;
use warnings;
use base 'Template::Provider';

sub _template_mtime { 1 }

sub _fetch_content {
    my ( $self, $file ) = @_;

    my $content = "<included $file>";
    return wantarray ? ( $content, '', 1 ) : $content;
}


package Form::Processor::Field::HtmlArea::Stash;
use strict;
use warnings;
use base 'Template::Stash';

sub get {
    my ($self, $arg ) = @_;
    my $value = ref $arg ? join( '.', @$arg ) : $arg;
    return "[ Template var '$value' ]";
}

package Form::Processor::Field::Template;
use strict;
use warnings;

my $template = Template->new(
    LOAD_TEMPLATES  => Form::Processor::Field::HtmlArea::Provider->new( INCLUDE_PATH => '/include/path' ),
    STASH           => Form::Processor::Field::HtmlArea::Stash->new( {} ),
) || die $Template::ERROR;





my $tidy;

sub validate {
    my $field = shift;
    return unless $field->SUPER::validate(@_);

    # Make sure template compiles
    my $output = '';
    my $value = $field->value;

    unless ( $template->process( \$value, {}, \$output ) ) {
        $field->add_error( $template->error );
        return;
    }

}




1;
