package codes;

our @EXPORT = qw/get_deb_codes get_full_name is_debian/;
use Exporter qw/import/;

my @codes_deb = (
	$ENV{DEBIAN_OLDSTABLE_CODE},
	$ENV{DEBIAN_STABLE_CODE},
	$ENV{UBUNTU_OLDLTS_CODE},
	$ENV{UBUNTU_LTS_CODE},
	$ENV{UBUNTU_STABLE_CODE},
	$ENV{MINT_OLDLTS_CODE},
	$ENV{MINT_LTS_CODE},
);

sub get_deb_codes {
	return @codes_deb;
}

sub get_full_name {
	my $code = shift;

	my $envname = uc($code) . "_FULLNAME";

	die "missing full name for $code\n" unless exists($ENV{$envname});

	return $ENV{$envname};
}

sub is_debian {
	my $code = shift;
	
	if($ENV{DEBIAN_STABLE_CODE} eq $code) {
		return 1;
	}
	if($ENV{DEBIAN_OLDSTABLE_CODE} eq $code) {
		return 1;
	}
	return 0;
}
