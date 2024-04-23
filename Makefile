tmp_dir := ./.build.tmp
LB_ROOT_PASSWORD ?= root

########################################################################
# Default variables
########################################################################
-include .env
export
########################################################################


all: usage

.PHONY: make-fast-build-sandbox
make-fast-build-sandbox:

## 3G - fail
## 4.7G used
$(tmp_dir):
	mkdir -p $(tmp_dir)
	sudo chown $${USER}: -R $(tmp_dir)
	sudo mount -t tmpfs -o size=6G  tmpfs $(tmp_dir)
	cp -r * $(tmp_dir)

$(tmp_dir)/config/chroot:
	echo "$(LB_ROOT_PASSWORD)" > config/includes.chroot_before_packages/root/passwd
	cd $(tmp_dir) && lb config

.PHONY: fast-prepare
fast-prepare: $(tmp_dir) $(tmp_dir)/config/chroot

# If it should go fast you can build the image in a tmpfs partition. This will
# use lots of memory. You have been warned!
fast-build: $(tmp_dir) $(tmp_dir)/config/chroot
	cd $(tmp_dir) && make build && \
	cp $(tmp_dir)/*-live-*.log .
	cp $(tmp_dir)/live-image-*.hybrid.iso .

.PHONY: fast-chroot
fast-chroot:
	cp -r * $(tmp_dir)
	cd $(tmp_dir) && sudo lb bootstrap chroot

usage:
	@echo "make config|build|clean|distclean"

.env:
	cp $@.example $@

config: .env
	sudo lb config
	mkdir -p chroot 2>/dev/null || true

build:
	echo "$(LB_ROOT_PASSWORD)" > config/includes.chroot_before_packages/root/passwd
	sudo lb build --debug --verbose
	rm -f config/includes.chroot_before_packages/root/passwd

clean:
	sudo lb clean

distclean: clean
	rm -f config/includes.chroot_before_packages/root/passwd
	sudo lb clean --purge --all
	sudo rm -f *.iso *.img *.list *.packages *.buildlog *.md5sum
	find config/hooks/ -type l -name '0*' -exec rm {} \;
	sudo umount -f $(tmp_dir) 2>/dev/null || true
	sudo rm -rf chroot .build $(tmp_dir)
	sudo rm -f config/binary
	sudo rm -f config/bootstrap
	sudo rm -f config/chroot
	sudo rm -f config/common
	sudo rm -f config/source
	sudo rm -f config/build

.PHONY: vagrant_clean
vagrant_clean:
	vagrant halt
	vagrant destroy
	rm -rf ./chroot
