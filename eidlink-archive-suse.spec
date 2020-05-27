Summary: GnuPG archive keys and configuration of the eIDLink package archive
Name: eidlink-archive-suse
Version: 2020
Release: 1
License: MIT

Source0: eidlink-archive-suse.repo
Source1: https://eid.static.bosa.fgov.be/f3dedd58.asc

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch

%description
This package contains the eIDLink repository GPG key as well as
configuration for zypper.

%prep
%setup -q -c -T
%{__install} -p -m0644 %{SOURCE1} .

%build

%install
%{__rm} -rf %{buildroot}

%{__install} -Dp -m0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/zypp/repos.d/eidlink-archive.repo
%{__install} -Dp -m0644 %{SOURCE1} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-EIDLINK-CONTINUOUS

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%config(noreplace) /etc/zypp/repos.d/eidlink-archive.repo
/etc/pki/rpm-gpg/RPM-GPG-KEY-EIDLINK-CONTINUOUS

%changelog
* Wed May 27 2020 <wouter.verhelst@zetes.com> - 2020-1
- Create new package for eIDLink, based on the eid-archive one.
