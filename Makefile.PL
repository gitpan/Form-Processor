use 5.006002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Form::Processor',
    VERSION_FROM      => 'lib/Form/Processor.pm', # finds $VERSION
    PREREQ_PM         => {
        'Rose::Object'      =>  0.015,
        'Scalar::Util'      =>  1.18,
        'Test::More'        =>  0,
        'UNIVERSAL::require'=>  0,
        'Locale::Maketext'  =>  '1.09',
        'DateTime',         =>  '0.34',
        'Email::Valid'      =>  0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Form/Processor.pm', # retrieve abstract from module
       AUTHOR         => 'Bill Moseley') : ()),
);
