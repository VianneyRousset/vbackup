PREFIX?=/usr
DISTNAME=vbackup
EXCL=--exclude \*.orig --exclude \*.pyc
ALL=vbackup.sh
VERS=$$(python3 ./sendto_silhouette.py --version)

DEST=$(DESTDIR)$(PREFIX)/bin

.PHONY: help dist install install-local tar_dist_classic tar_dist clean generate_pot update_po mo
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

mdhelp: # Render help for each of the Makefile recipes in a markdown friendly manner
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf " - **$$(echo $$l | cut -f 1 -d':')**:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: install
install: mo # Install is used by dist or use this with this command `sudo make install` to install for all users
	mkdir -p $(DEST)
	@# CAUTION: cp -a does not work under fakeroot. Use cp -r instead.
	install -m 755 vbackup.sh $(DEST)/vbackup
	
.PHONY: tar_dist_classic
tar_dist_classic: clean mo # Create a compressed tarball archive file (.tar.bz2) that contains the distribution files for the Inkscape Silhouette project. (Using a fixed list defined in $ALL)
	name=$(DISTNAME)-$(VERS); echo "$$name"; echo; \
	tar jcvf $$name.tar.bz2 $(EXCL) --transform="s,^,$$name/," $(ALL)
	grep about_version ./sendto_silhouette.inx 
	@echo version should be $(VERS)

.PHONY: tar_dist
tar_dist: mo # Create a compressed tarball archive file (.tar.bz2) that contains the distribution files for the Inkscape Silhouette project. (Using distutils.core parameter like format bztar)
	python3 setup.py sdist --format=bztar
	mv dist/*.tar* .
	rm -rf dist

.PHONY: clean
clean: # Cleanup generated/compiled files and restore project back to nominal state
