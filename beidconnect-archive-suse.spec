Summary: GnuPG archive keys and configuration of the BeIDConnect package archive
Name: beidconnect-archive-suse
Version: 2020
Release: 1
License: MIT

Source0: beidconnect-archive-suse.repo
Source1: https://eid.static.bosa.fgov.be/69fa2d05.asc

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch

%description
This package contains the BeIDConnect repository GPG key as well as
configuration for zypper.

%prep
%setup -q -c -T
%{__install} -p -m0644 %{SOURCE1} .

%build

%install
%{__rm} -rf %{buildroot}

%{__install} -Dp -m0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/zypp/repos.d/beidconnect-archive.repo
%{__install} -Dp -m0644 %{SOURCE1} %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-BEIDCONNECT-CONTINUOUS

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%config(noreplace) /etc/zypp/repos.d/beidconnect-archive.repo
/etc/pki/rpm-gpg/RPM-GPG-KEY-BEIDCONNECT-CONTINUOUS

%changelog
* Wed May 27 2020 <wouter.verhelst@zetes.com> - 2020-1
- Create new package for BeIDConnect, based on the eid-archive one.
