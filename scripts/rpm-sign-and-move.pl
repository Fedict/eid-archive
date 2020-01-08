#!/usr/bin/perl -w

use strict;
use warnings;

use File::Copy;
use File::Path qw/make_path/;
use Cwd qw/cwd/;

my %distvers = (
        el => { versions => [ $ENV{CENTOS_OLDSTABLE_VERSION}, $ENV{CENTOS_STABLE_VERSION} ], dirpart => 'el' },
        fedora => { versions => [ $ENV{FEDORA_OLDSTABLE_VERSION}, $ENV{FEDORA_STABLE_VERSION} ], dirpart => 'fedora' },
        suse => { versions => [ $ENV{OPENSUSE_OLDSTABLE_VERSION}, $ENV{OPENSUSE_STABLE_VERSION} ], dirpart => 'opensuse' },
);

my $builddir = cwd();

foreach my $file(@ARGV) {
        print STDERR "checking $file\n";
        my $qf = '%{NAME}|%{VERSION}|%{RELEASE}|%{ARCH}\n';
        open my $query, "rpm --queryformat '$qf' -qp $file|";
        while(<$query>) {
                chomp;
                my ($name, $version, $release, $arch) = split/\|/;
                (undef, undef, my $dist) = split/-/, $name;
                my $dirdist = $distvers{$dist}{dirpart};
                foreach my $vers(@{$distvers{$dist}{versions}}) {
                        my $targetdir = "/srv/repo/repo/rpm/$dirdist/$vers/RPMS/$arch/";
                        my $target = "$targetdir/$name-$version-$release.$arch.rpm";
                        next if (-f $target);
                        make_path($targetdir);
                        move($file, $target);
                        system("rpmsign", "--resign", "--key-id=" . $ENV{GPG_KEY_ID}, $target);
                        chdir($targetdir);
                        chdir("../..");
                        system("createrepo", ".");
                        if($dist eq "suse") {
                                chdir("repodata");
                                system("gpg", "--yes", "--batch", "--passphrase", "", "--default-key", $ENV{GPG_KEY_ID}, "--no-tty", "-b", "--armor", "repomd.xml");
                        }
                        chdir($builddir);
                }
        }
}
