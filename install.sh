#!/bin/bash

# The rpi-fake-pcr.bin file is a storege for fake keys used for
# PCRs 0, 1, 2, 3 and 6 since RPi4 does not have secure boot:
# This file must be preserved if it exists!
if [[ ! -f /boot/firmware/rpi-fake-pcr.bin ]]
then
    dd if=/dev/random of=/boot/firmware/rpi-fake-pcr.bin bs=32 count=5
fi

# Better to use flash-kernel to use placeholders and persist to update:
rm -f /boot/firmware/boot.scr /boot/firmware/boot.scr.uimg
cp bootscr-tpm.rpi /etc/flash-kernel/bootscript/bootscr.rpi
flash-kernel

cp build/u-boot.bin /boot/firmware/
cp build/tpm-soft-spi.dtbo /boot/firmware/overlays/

cat <<EOF

Don't forget to change config.txt like this:

[all]
kernel=u-boot.bin
dtoverlay=tpm-soft-spi
#kernel=vmlinuz
#cmdline=cmdline.txt
#initramfs initrd.img followkernel
EOF
