use inc::Module::Install 0.68;


name 'Form-Processor';
all_from 'lib/Form/Processor.pm';

requires 'Rose::Object'       => '0.015';
requires 'Scalar::Util'       => '1.18';
requires 'UNIVERSAL::require' => '0';
requires 'Locale::Maketext'   => '1.09';
requires 'Module::Find'       => '0.05';

build_requires 'Test::More' => 0;

# DateTimeManip, DateTimeDMYHM, DateTime

recommends 'DateTime'                    => '0.34';
recommends 'Date::Manip'                 => '5.44';
recommends 'DateTime::Format::DateManip' => '0.04';

# Email
recommends 'Email::Valid' => '0';


# Template
recommends 'Template' => '2.19';

# HtmlArea -- requires Tidylib
recommends 'HTML::Tidy' => '1.06';
recommends 'File::Temp' => '0.16';

# CIDR_List
recommends 'Net::CIDR' => '0.11';

# MD5_Password
recommends 'Digest::MD5' => '2.36';



auto_install;
WriteAll;
