use inc::Module::Install 0.91;

name 'TTV';
abstract 'Torresmos.TV';
author 'Pedro Melo <melo@simplicidade.org>';
version '0.01';
license 'artistic2';
perl_version '5.008';

# Specific dependencies
requires 'AnyEvent'           => 0;
requires 'AnyEvent::HTTP'     => 0;
requires 'JSON'               => 0;
requires 'Method::Signatures' => 0;
requires 'Moose'              => 0;

test_requires 'Test::More' => '0.96';
test_requires 'Test::Compile' => 0;

recommends 'JSON::XS' => 0;


auto_install;
WriteAll;
