Summary: GnuPG archive keys and configuration of the Belgian eID package archive
Name: eid-archive-fedora
Version: 2021
Release: 1
License: GPL
URL: https://eid.belgium.be/

Source0: https://eid.belgium.be/10a04d46.asc
Source1: https://eid.belgium.be/6773d225.asc
Source2: eid-archive-fedora.repo
Source3: https://eid.belgium.be/67da21a4.asc

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch

%description
This package contains the Belgian eID repository GPG key as well as
configuration for yum.

%prep
%setup -q -c -T
%{__install} -p -m0644 %{SOURCE0} .
%{__install} -p -m0644 %{SOURCE1} .

%build

%install
%{__rm} -rf %{buildroot}

%{__install} -Dp -m0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-CONTINUOUS
%{__install} -Dp -m0644 %{SOURCE1} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE
%{__install} -Dp -m0644 %{SOURCE2} %{buildroot}%{_sysconfdir}/yum.repos.d/eid-archive.repo
%{__install} -Dp -m0644 %{SOURCE1} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE-2025

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%config(noreplace) /etc/yum.repos.d/eid-archive.repo
/etc/pki/rpm-gpg/RPM-GPG-KEY-BEID-CONTINUOUS
/etc/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE
/etc/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE-2025

%changelog
* Mon Aug 15 2025 <wouter.verhelst@zetes.com> - 2025-1
- Add new 2025 key, will start to be used a few months from now, but do
  it now to allow for a reasonable key rollover

* Mon Nov 29 2021 <wouter.verhelst@zetes.com> - 2021-1
- Move files repository from http to https
- Update all URLs in the .spec file to https, not http

* Tue Jun  7 2016 <wouter.verhelst@fedict.be> - 2016-2
- Merge mirrors into one repository section

* Thu Mar 24 2016 <wouter.verhelst@fedict.be> - 2016-1
- Add the files2 mirror as a separate repository, to remove a SPOF

* Fri Oct 23 2015 <wouter.verhelst@fedict.be> - 2015-3
- Add the candidate repository

* Wed Jun 10 2015 <wouter.verhelst@fedict.be> - 2015-2
- Remove %post scriptlet, it doesn't work; you can't install a GPG key while
  the RPM lock is held.

* Wed Jan 7 2015 <wouter.verhelst@fedict.be> - 2015-1
- Rebuild to remove eid-archive-fedora.repo artifact from rpmbuild directory,
  so that repositories work again (sigh).

* Wed Aug 20 2014 <wouter.verhelst@fedict.be> - 2014-4
- Update link to main archive as well, now. We'll leave the old layout
  functional for now, so that upgrades continue working.

* Thu Aug 1 2014 <wouter.verhelst@fedict.be> - 2014-3
- Update link to continuous archive, so that multiarch can actually
  work. Will need to do something similar for main archive, but that's
  for later.

* Thu Jul 17 2014 <wouter.verhelst@fedict.be> - 2014-2
- Install the GPG keys from the postinst script (with appropriate message).
- Output a message to notify the user that this is only the first step.

* Thu Jun 12 2014 <wouter.verhelst@fedict.be> - 2014-1
- Create, with inspiration from the epel-release package
