%define debug_package %{nil}
%{!?qmake_bin: %define qmake_bin qmake-qt4}

Summary: Audio curve generator for Natron/Nuke
Name: audio2ascii

Version: 1.0alpha1
Release: 1
License: GPL

Group: Applications/Multimedia
URL: https://github.com/rcspam/audio2ascii
Source: %{name}-%{version}.tar.gz
BuildRequires: qt-devel
Requires: sox

%description
Audio curve generator for Natron/Nuke

%prep
%setup -q

%build
%{qmake_bin} CONFIG-=debug CONFIG+=release PREFIX=/usr
make

%install
make INSTALL_ROOT=%{buildroot} install

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_bindir}/audio2ascii*
%{_datadir}/applications/audio2ascii*.desktop
%{_datadir}/pixmaps/audio2ascii.png
%{_docdir}/audio2ascii*

%changelog
#
