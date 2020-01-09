#!/usr/bin/perl -w

use strict;
use warnings;

use Dpkg::Control::HashCore;

my $chg = Dpkg::Control::HashCore->new;

if(!exists($ENV{REPREPRO_BASE_DIR})) {
	$ENV{REPREPRO_BASE_DIR} = '/srv/repo/reprepro';
}

my @codes = (
	$ENV{DEBIAN_OLDSTABLE_CODE},
	$ENV{DEBIAN_STABLE_CODE},
	$ENV{UBUNTU_OLDLTS_CODE},
	$ENV{UBUNTU_LTS_CODE},
	$ENV{UBUNTU_STABLE_CODE},
	$ENV{MINT_OLDLTS_CODE},
	$ENV{MINT_LTS_CODE},
);

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
