Summary: GnuPG archive keys and configuration of the Belgian eID package archive
Name: eid-archive-suse
Version: 2016
Release: 2
License: GPL
URL: http://eid.belgium.be/

Source0: http://eid.belgium.be/10a04d46.asc
Source1: http://eid.belgium.be/6773d225.asc
Source2: eid-archive-suse.repo

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch

%description
This package contains the Belgian eID repository GPG key as well as
configuration for zypper.

%prep
%setup -q -c -T
%{__install} -p -m0644 %{SOURCE0} .
%{__install} -p -m0644 %{SOURCE1} .

%build

%install
%{__rm} -rf %{buildroot}

%{__install} -Dp -m0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-CONTINUOUS
%{__install} -Dp -m0644 %{SOURCE1} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE
%{__install} -Dp -m0644 %{SOURCE2} %{buildroot}%{_sysconfdir}/zypp/repos.d/eid-archive.repo

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%config(noreplace) /etc/zypp/repos.d/eid-archive.repo
/etc/pki/rpm-gpg/RPM-GPG-KEY-BEID-CONTINUOUS
/etc/pki/rpm-gpg/RPM-GPG-KEY-BEID-RELEASE

%changelog
* Tue Jun  7 2016 <wouter.verhelst@fedict.be> - 2016-2
- Merge mirrors into one repository section

* Thu Mar 24 2016 <wouter.verhelst@fedict.be> - 2016-1
- Add the files2 mirror as a separate repository, to remove a SPOF

* Fri Oct 23 2015 <wouter.verhelst@fedict.be> - 2015-3
- Add the candidate repository

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
