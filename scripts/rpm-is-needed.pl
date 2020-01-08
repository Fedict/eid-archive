#!/usr/bin/perl -w

use strict;
use warnings;

my %distvers = (
	el => { versions => [ $ENV{CENTOS_OLDSTABLE_VERSION}, $ENV{CENTOS_STABLE_VERSION} ], dirpart => 'el' },
	fedora => { versions => [ $ENV{FEDORA_OLDSTABLE_VERSION}, $ENV{FEDORA_STABLE_VERSION} ], dirpart => 'fedora' },
	suse => { versions => [ $ENV{OPENSUSE_OLDSTABLE_VERSION}, $ENV{OPENSUSE_STABLE_VERSION} ], dirpart => 'opensuse' },
);

foreach my $file(@ARGV) {
    print STDERR "checking $file\n";
	my $qf = '%{NAME}|%{VERSION}|%{RELEASE}|%{ARCH}\n';
	open my $query, "rpm --queryformat '$qf' -qp $file|";
	while(<$query>) {
		chomp;
		my ($name, $version, $release, $arch) = split/|/;
		(undef, undef, my $dist) = split/-/, $name;
		my $dirdist = $distvers{$dist}{dirpart};
		foreach my $vers($distvers{$dist}) {
			next if (-f "/srv/repo/repo/rpm/$dirdist/$vers/RPMS/$arch/$name-$version-$release.$arch.rpm");
			print "/srv/repo/repo/rpm/$dirdist/$vers/RPMS/$arch/$name-$version-$release.$arch.rpm\n";
		}
	}
}

exit 1;
