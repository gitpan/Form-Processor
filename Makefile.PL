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
        'UNIVERSAL::require'=>  0,
        'Locale::Maketext'  =>  1.09,
        'DateTime',         =>  0.34,
        'Email::Valid'      =>  0,
        'Test::More'        =>  0,
        #'Template'          => 0,   # Validate templates?
        'File::Temp'        =>  0,
        #'HTML::Tidy'        =>  0,  # Requires tidylib
        'Module::Find'      => 0.05,

        # Maybe remove -- DateManip has bad timezone issues
        'DateTime::Format::DateManip' => '0.04',
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Form/Processor.pm', # retrieve abstract from module
       AUTHOR         => 'Bill Moseley') : ()),
);
