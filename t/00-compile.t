#!perl

use strict;
use warnings;
use Test::More;
use Test::Compile;

my @excludes = ('TTV::Roles');

my %files;
for my $class (@excludes) {
  $class =~ s{::}{/}g;
  $files{"lib/$class.pm"} = 1;
}

all_pm_files_ok(grep { !$files{$_} } all_pm_files('lib'));

done_testing();
