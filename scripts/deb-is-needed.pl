#!/usr/bin/perl -w

use strict;
use warnings;

use Dpkg::Control::HashCore;

my $chg = Dpkg::Control::HashCore->new;

if(!exists($ENV{REPREPRO_BASE_DIR})) {
	$ENV{REPREPRO_BASE_DIR} = '/srv/repo/reprepro';
}

foreach my $file(@ARGV) {
	my $found = 0;
	$chg->load($file);
	my $version = $chg->{Version};
	my $dist = $chg->{Distribution};
	$dist =~ s,-,/,g;
	my @arch = split(/ /, $chg->{Architecture});
	my $source = $chg->{Source};

	foreach my $arch(@arch) {
		open my $reprepro, "/usr/bin/reprepro -A $arch list $dist $source|";
		while(<$reprepro>) {
			$found = 1;
			chomp;
			(undef, undef, my $repovers) = split(/ /);
			if($version ne $repovers) {
				exit 0;
			}
		}
	}
}

exit 1 if $found;
exit 0;
