#!/usr/bin/perl

use File::Basename;
use Data::Dumper;
use Dpkg::Control::HashCore;

use lib join("/", dirname($0), "lib");

use Reprepro::Distribution;
use codes;

my $basedir = "/srv/repo/reprepro";
if(exists($ENV{REPREPRO_BASE_DIR})) {
	$basedir = $ENV{REPREPRO_BASE_DIR};
}
my $dist = Reprepro::Distribution->new("$basedir/conf/distributions");

my $key = $ENV{GPG_KEY_ID};
my $testkey = $key;
if(exists($ENV{GPG_TEST_KEY_ID})) {
	$testkey = $ENV{GPG_TEST_KEY_ID};
}

foreach my $code(get_deb_codes()) {
	next unless defined($code);
	next if(exists($dist->{index}{$code}));
        die "missing code $code from reprepro config. Please build the eid-mw packages first, then try this one."
}
