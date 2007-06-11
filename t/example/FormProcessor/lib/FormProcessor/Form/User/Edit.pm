package FormProcessor::Form::User::Edit;
use strict;
use warnings;
use base 'Form::Processor';

sub profile {
    return {
        required => {
            first_name  => 'Text',
            last_name   => 'Text',
            username    => 'Username',
            email       => 'Email',
            color       => 'Select',
            age         => 'Integer',
            css_color   => 'Select',
            zip         => 'USZipcode',
        },
        optional => {
            optional_color => 'Select',
            married     => 'Boolean',
            rating      => 'OneToTen',
            pets        => 'Multiple',
            password    => 'Password',
            password_chk => 'Password',
            share       => 'Checkbox',
            file        => 'Upload',
            text        => 'TextArea',
        },

        # both must be entered
        dependency => [
            [qw/password password_chk /],
        ],

    };
}


sub options_pets {
    my $id = 1;
    return map { $id++, $_ } qw/ Cat Dog Bird Snake Alligator /;
}

sub options_color {
    my $id = 1;
    return map { $id++, $_ } qw/ Red Green Blue Yellow Pink /;
}

*options_optional_color = \&options_css_color;

sub options_css_color {
    my $id = 1;
    return map { $id++, $_ } qw/
        AliceBlue
        AntiqueWhite
        Aqua
        Aquamarine
        Azure
        Beige
        Bisque
        Black
        BlanchedAlmond
        Blue
        BlueViolet
        Brown
        BurlyWood
        CadetBlue
        Chartreuse
        Chocolate
        Coral
        CornflowerBlue
        Cornsilk
        Crimson
        Cyan
        DarkBlue
        DarkCyan
        DarkGoldenRod
        DarkGray
        DarkGrey
        DarkGreen
        DarkKhaki
        DarkMagenta
        DarkOliveGreen
        Darkorange
        DarkOrchid
        DarkRed
        DarkSalmon
        DarkSeaGreen
        DarkSlateBlue
        DarkSlateGray
        DarkSlateGrey
        DarkTurquoise
        DarkViolet
        DeepPink
        DeepSkyBlue
        DimGray
        DimGrey
        DodgerBlue
        FireBrick
        FloralWhite
        ForestGreen
        Fuchsia
        Gainsboro
        GhostWhite
        Gold
        GoldenRod
        Gray
        Grey
        Green
        GreenYellow
        HoneyDew
        HotPink
        IndianRed
        Indigo
        Ivory
        Khaki
        Lavender
        LavenderBlush
        LawnGreen
        LemonChiffon
        LightBlue
        LightCoral
        LightCyan
        LightGoldenRodYellow
        LightGray
        LightGrey
        LightGreen
        LightPink
        LightSalmon
        LightSeaGreen
        LightSkyBlue
        LightSlateGray
        LightSlateGrey
        LightSteelBlue
        LightYellow
        Lime
        LimeGreen
        Linen
        Magenta
        Maroon
        MediumAquaMarine
        MediumBlue
        MediumOrchid
        MediumPurple
        MediumSeaGreen
        MediumSlateBlue
        MediumSpringGreen
        MediumTurquoise
        MediumVioletRed
        MidnightBlue
        MintCream
        MistyRose
        Moccasin
        NavajoWhite
        Navy
        OldLace
        Olive
        OliveDrab
        Orange
        OrangeRed
        Orchid
        PaleGoldenRod
        PaleGreen
        PaleTurquoise
        PaleVioletRed
        PapayaWhip
        PeachPuff
        Peru
        Pink
        Plum
        PowderBlue
        Purple
        Red
        RosyBrown
        RoyalBlue
        SaddleBrown
        Salmon
        SandyBrown
        SeaGreen
        SeaShell
        Sienna
        Silver
        SkyBlue
        SlateBlue
        SlateGray
        SlateGrey
        Snow
        SpringGreen
        SteelBlue
        Tan
        Teal
        Thistle
        Tomato
        Turquoise
        Violet
        Wheat
        White
        WhiteSmoke
        Yellow
        YellowGreen
    /;
}

# Validate a specific field

sub validate_color {
    my ( $form, $field ) = @_;

    $field->add_error( 'Sorry, pick a better color' )
        if $field->value == 2;
}


sub validate_password_chk {
    my ( $self, $field ) = @_;

    for ( qw/ password password_chk / ) {
        return if $self->field( $_ )->errors;
    }

    $field->add_error( 'Passwords do not match' )
        unless $field->value eq $self->field( 'password' )->value;
}



1;



