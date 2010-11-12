package TTV::Setup;

# ABSTRACT: Setup our calling class according to its function

use strict;
use warnings;
use utf8;
use feature ();
use Carp                 ();
use namespace::autoclean ();

sub import {
  my ($class, $command) = @_;
  my $into = caller;
  my $clean;

  return $into unless $command;

  feature->import(':5.12');
  utf8->import();

  if ($command eq 'class') {
    require Moose;
    Moose->import({into => $into});
    $clean++;
  }
  elsif ($command eq 'role') {
    require Moose::Role;
    Moose::Role->import({into => $into});
    $clean++;
  }
  elsif ($command eq 'library') {
    no strict 'refs';
    require Exporter;
    push @{"${into}::ISA"}, 'Exporter';
  }
  else {
    Carp::croak "unknown command $command in $class,";
  }

  namespace::autoclean->import(-cleanee => $into) if $clean;

  return $into;
}

1;
