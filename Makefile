tmp_dir := ./.build.tmp

all: usage

.PHONY: make-fast-build-sandbox
make-fast-build-sandbox:

$(tmp_dir):
	mkdir -p $(tmp_dir)
	sudo mount -t tmpfs -o size=4G  tmpfs $(tmp_dir)
	sudo cp -r * $(tmp_dir)

# If it should go fast you can build the image in a tmpfs partition. This will
# use lots of memory. You have been warned!
fast-build: $(tmp_dir)
	cd $(tmp_dir) && sudo lb config && sudo lb build
	-cp $(tmp_dir)/*-live-*.log .
	cp $(tmp_dir)/live-image-*.hybrid.iso .

usage:
	@echo "make config|build|clean|distclean"

config:
	sudo lb config
	mkdir -p chroot 2>/dev/null || true

build: config
	sudo lb build --debug --verbose

clean:
	sudo lb clean
	sudo rm -f *.log

distclean: clean
	sudo lb clean --purge --all
	sudo rm -f *.iso *.img *.list *.packages *.buildlog *.md5sum
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
