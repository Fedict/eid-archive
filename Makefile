rpms:
	mkdir -p $(HOME)/rpmbuild/SOURCES
	cp *.repo $(HOME)/rpmbuild/SOURCES/
	cp *.asc $(HOME)/rpmbuild/SOURCES/
	for i in *spec; do rpmbuild -ba $$i; done
