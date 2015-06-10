Name: eid-archive-suse
Version: 2014
Release: 3
Summary: GnuPG archive keys and configuration of the Belgian eID package archive

URL: http://eid.belgium.be/
Source0: http://eid.belgium.be/10a04d46.asc
Source1: http://eid.belgium.be/6773d225.asc
Source2: eid-archive-suse.repo
License: GPL

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch

%description
This package contains the Belgian eID repository GPG key as well as
configuration for zypper.

%prep
%setup -q -c -T
install -pm 644 %{SOURCE0} .
install -pm 644 %{SOURCE1} .

%build

%install
rm -rf $RPM_BUILD_ROOT

install -Dpm 644 %{SOURCE0} $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-CONTINUOUS
install -Dpm 644 %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE

install -dm 755 $RPM_BUILD_ROOT%{_sysconfdir}/zypp/repos.d
install -pm 644 %{SOURCE2} $RPM_BUILD_ROOT%{_sysconfdir}/zypp/repos.d/eid-archive.repo

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%config(noreplace) /etc/zypp/repos.d/*
/etc/pki/rpm-gpg/*

%changelog
* Wed Jun 10 2015 <wouter.verhelst@fedict.be> - 2015-2
- Remove %post scriptlet, it doesn't work; you can't install a GPG key while
  the RPM lock is held.
* Wed Nov 05 2014 <wouter.verhelst@fedict.be> - 2014-3
- Use $releasever to select the release, rather than hardcoding it.
* Thu Jul 17 2014 <wouter.verhelst@fedict.be> - 2014-2
- Install the GPG keys from the postinst script (with appropriate message).
- Output a message to notify the user that this is only the first step.
* Thu Jun 12 2014 <wouter.verhelst@fedict.be> - 2014-1
- Create, with inspiration from the epel-release package
