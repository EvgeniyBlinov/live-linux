# live-linux

Linux live-build debian based live with persistence for remote install by ssh.


### Vagrant add box

```
vagrant box add debian/bullseye64 ./debian__bullseye64__v11.20240212.1.box
```

### Vagrant sync time

```
date +%s |vagrant ssh -- -t 'cat | xargs -I{} sudo date -s @{}; sudo hwclock -w'
```


### Build in vagrant machine

```
vagrant ssh

cd /vagrant/live-linux/

## update datetime
sudo systemctl restart ntp
sudo systemctl status ntp
date
sudo hwclock -w

make fast-build
```

### Create persistent file

```
export size=100
export outputfile=remoteadmin.dat
export freeloop=$(losetup -f)

dd if=/dev/zero  bs=1M count=$size | tr '\000' '\377' > "$outputfile"
sync


sudo losetup -P $freeloop "$outputfile"

sudo losetup -a

mkfs -t ext4 -E nodiscard -L persistence $freeloop
sync

mkdir -p /mnt/usb

mount $freeloop /mnt/usb

cat > /mnt/usb/persistence.conf <<-'EOF'
/etc link,source=etc
/root link,source=root
EOF

mkdir /mnt/usb/{etc,root}

umount $freeloop
losetup -d $freeloop
```

#### Ventoy example

```
mkdir -p ./ventoy
cat > ./ventoy/ventoy.json <<-'EOF'
{
    "control": [
        { "VTOY_MENU_LANGUAGE": "en_US" },
        { "VTOY_DEFAULT_MENU_MODE": "0" },
        { "VTOY_TREE_VIEW_MENU_STYLE": "0" },
        { "VTOY_FILT_DOT_UNDERSCORE_FILE": "1" },
        { "VTOY_SORT_CASE_SENSITIVE": "0" },
        { "VTOY_MAX_SEARCH_LEVEL": "max" },
        { "VTOY_DEFAULT_SEARCH_ROOT": "/ISO" },
        { "VTOY_MENU_TIMEOUT": "3" },
        { "VTOY_DEFAULT_IMAGE": "/ISO/live-image-amd64.hybrid.iso" },
        { "VTOY_FILE_FLT_EFI": "1" },
        { "VTOY_DEFAULT_KBD_LAYOUT": "QWERTY_USA" },
        { "VTOY_WIN11_BYPASS_CHECK": "1" },
        { "VTOY_WIN11_BYPASS_NRO": "1" },
        { "VTOY_HELP_TXT_LANGUAGE": "en_US" },
        { "VTOY_SECONDARY_BOOT_MENU": "1" },
        { "VTOY_SECONDARY_TIMEOUT": "3" }
    ],
    "persistence": [
        {
            "image": "/ISO/live-image-amd64.hybrid.iso",
            "backend": "/persistence/remoteadmin.dat",
            "autosel": 2,
            "timeout": 3
        }
    ]
}
EOF
```
