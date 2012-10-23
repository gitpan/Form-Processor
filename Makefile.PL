
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "validate and process form data",
  "AUTHOR" => "Bill Moseley <mods\@hank.org>",
  "BUILD_REQUIRES" => {
    "Date::Manip" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Form-Processor",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Form::Processor",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Data::Dumper" => 0,
    "Data::UUID" => 0,
    "DateTime" => 0,
    "DateTime::Format::DateManip" => 0,
    "Digest::MD5" => 0,
    "Email::Valid" => 0,
    "Encode" => 0,
    "File::Temp" => 0,
    "HTML::Tidy" => 0,
    "Locale::Maketext" => 0,
    "Net::CIDR" => 0,
    "Rose::Object" => 0,
    "Rose::Object::MakeMethods::Generic" => 0,
    "Scalar::Util" => 0,
    "Template::Parser" => 0,
    "UNIVERSAL::require" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.122970",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



