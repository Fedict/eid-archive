#!/usr/bin/perl -w

use strict;
use warnings;

use Dpkg::Control::HashCore;

my $chg = Dpkg::Control::HashCore->new;

$chg->load($ARGV[0]);
print $chg->{Distribution} . "\n";
