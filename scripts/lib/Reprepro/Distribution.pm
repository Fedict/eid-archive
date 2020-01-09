#!/usr/bin/perl -w

package Reprepro::Distribution;

use Dpkg::Control::HashCore;
use parent(Dpkg::Interface::Storable);

sub parse {
	my ($self, $fh, $desc) = @_;

	$self->{sections} = [];
	$self->{index} = {};

	while(1) {
		my $cdata = Dpkg::Control::HashCore->new();
		last if not $cdata->parse($fh, $desc);
		push @{$self->{sections}}, $cdata;
		$self->{index}{$cdata->{Codename}} = $cdata;
	}
}

sub add_dist {
	my ($self, $new) = @_;
	push @{$self->{sections}}, $new;
	$self->{index}{$new->{Codename}} = $new;
}

sub output {
	my ($self, $fh) = @_;

	my $str = "";
	my $newline = "";

	foreach my $section(@{$self->{sections}}) {
		print $fh $newline if defined($fh);
		$str .= $newline . $section->output($fh);
		$newline = "\n";
	}
	return $str;
}

sub new {
	my ($class, @args) = @_;

	my $self = {};

	bless $self, $class;
	if(scalar(@args) == 1) {
		$self->load($args[0]);
	}

	return $self;
}

1;
