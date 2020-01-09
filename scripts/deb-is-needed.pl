#!/usr/bin/perl -w

use strict;
use warnings;

use Dpkg::Control::HashCore;
use File::Basename;

use lib join("/", dirname($0), "lib");

use codes;

my $chg = Dpkg::Control::HashCore->new;

if(!exists($ENV{REPREPRO_BASE_DIR})) {
	$ENV{REPREPRO_BASE_DIR} = '/srv/repo/reprepro';
}

my @codes = get_deb_codes;

foreach my $file(@ARGV) {
	$chg->load($file);
	my $version = $chg->{Version};
	my @arch = split(/ /, $chg->{Architecture});
	my $source = $chg->{Source};

	foreach my $arch(@arch) {
		foreach my $code(@codes) {
			next unless defined($code);
			foreach my $prefix("candidate/", "continuous/", "") {
				open my $reprepro, "/usr/bin/reprepro -A $arch list $prefix$code $source|";
				while(<$reprepro>) {
					chomp;
					(undef, undef, my $repovers) = split(/ /);
					if($version eq $repovers) {
						exit 1;
					}
				}
				close $reprepro;
			}
		}
	}
}

exit 0;
