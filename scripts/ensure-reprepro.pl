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
	my $candidate = Dpkg::Control::HashCore->new;
	my $proposed = Dpkg::Control::HashCore->new;
	my $continuous = Dpkg::Control::HashCore->new;
	my $plain = Dpkg::Control::HashCore->new;
	my $full = get_full_name($code);

	$continuous->{Codename} = "continuous/$code";
	$continuous->{Suite} = "experimental/$code";
	$continuous->{FakeComponentPrefix} = $code;
	$continuous->{Origin} = "BOSA";
	$continuous->{Label} = "BOSA";
	$continuous->{NotAutomatic} = "yes";
	$continuous->{Description} = "BOSA eID packages for $full - unsupported development builds";
	$continuous->{Architectures} = "source amd64 i386";
	if(is_debian($code)) {
		$continouos->{Architectures} .= " armhf";
	}
	$continuous->{Components} = "main";
	$continuous->{SignWith} = $testkey;

	$candidate->{Codename} = "candidate/$code";
	$candidate->{Suite} = "experimental/$code";
	$candidate->{FakeComponentPrefix} = $code;
	$candidate->{Origin} = "BOSA";
	$candidate->{Label} = "BOSA";
	$candidate->{NotAutomatic} = "yes";
	$candidate->{Description} = "BOSA eID packages for $full - unsupported development builds";
	$candidate->{Architectures} = "source amd64 i386";
	if(is_debian($code)) {
		$continouos->{Architectures} .= " armhf";
	}
	$candidate->{Components} = "main";
	$candidate->{SignWith} = $testkey;

	$proposed->{Codename} = "proposed/$code";
	$proposed->{Suite} = "experimental/$code";
	$proposed->{FakeComponentPrefix} = $code;
	$proposed->{Origin} = "BOSA";
	$proposed->{Label} = "BOSA";
	$proposed->{NotAutomatic} = "yes";
	$proposed->{Description} = "BOSA eID packages for $full - unsupported development builds";
	$proposed->{Architectures} = "source amd64 i386";
	if(is_debian($code)) {
		$continouos->{Architectures} .= " armhf";
	}
	$proposed->{Components} = "main";
	$proposed->{SignWith} = $testkey;

	$plain->{Codename} = "$code";
	$plain->{Suite} = "$code";
	$plain->{Origin} = "BOSA";
	$plain->{Label} = "BOSA";
	$plain->{Description} = "BOSA eID packages for $full - unsupported development builds";
	$plain->{Architectures} = "source amd64 i386";
	if(is_debian($code)) {
		$continouos->{Architectures} .= " armhf";
	}
	$plain->{Components} = "main";
	$plain->{SignWith} = $key;

	$dist->add_dist($continuous);
	$dist->add_dist($proposed);
	$dist->add_dist($candidate);
	$dist->add_dist($plain);

	my $incoming = Dpkg::Control::HashCore->new;
	$incoming->load("$basedir/conf/incoming");
	$incoming->{Allow} .= "candidate-$code>candidate/$code continuous-$code>continuous/$code $code";
	$incoming->save("$basedir/conf/incoming");
}

$dist->save("$basedir/conf/distributions");

