#!/usr/bin/perl -w

use strict;
use warnings;

my $qf = '%{NAME}\n';
foreach my $file(@ARGV) {
	open my $query, "rpm --queryformat '$qf' -qp $file|";
	while(<$query>) {
		chomp;
		(undef, undef, my $dist) = split/-/;
		if($name eq "suse") {
			exit 0;
		}
	}
}
exit 1;
