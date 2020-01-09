#!/usr/bin/perl -w

use strict;
use warnings;

use Dpkg::Control::HashCore;

my $chg = Dpkg::Control::HashCore->new;

if(!exists($ENV{REPREPRO_BASE_DIR})) {
	$ENV{REPREPRO_BASE_DIR} = '/srv/repo/reprepro';
}

my $found = 0;

my @codes = (
	$ENV{DEBIAN_OLDSTABLE_CODE},
	$ENV{DEBIAN_STABLE_CODE},
	$ENV{UBUNTU_OLDLTS_CODE},
	$ENV{UBUNTU_LTS_CODE},
	$ENV{UBUNTU_STABLE_CODE},
	$ENV{MINT_OLDLTS_CODE},
	$ENV{MINT_LTS_CODE},
);

my @targets = ();
my %source;

foreach my $file(@ARGV) {
	$chg->load($file);
	my $version = $chg->{Version};
	my @arch = split(/ /, $chg->{Architecture});
	my $source = $chg->{Source};

	CODE: foreach my $code(@codes) {
		next unless defined($code);
		foreach my $prefix("candidate/", "continuous", "") {
			open my $reprepro, "/usr/bin/reprepro -A source list $prefix$code $source|";
			while(<$reprepro>) {
				chomp;
				(undef, undef, my $repovers) = split(/ /);
				if($version eq $repovers) {
					$source{code} = $code;
					$source{prefix} = $prefix;
					last CODE;
				}
			}
		}
	}
	foreach my $target(@codes) {
		next unless defined($target);
		next if($target eq $source{code} && $source{prefix} eq "");
		print "copying from " . $source{prefix} . $source{code} . " to $target\n";
		system("/usr/bin/reprepro", "copysrc", $target, $source{prefix} . $source{code}, $source, $version);
	}
}
