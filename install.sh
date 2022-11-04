#!/bin/bash

# The rpi-fake-pcr.bin file is a storege for fake keys used for
# PCRs 0, 1, 2, 3 and 6 since RPi4 does not have secure boot:
# This file must be preserved if it exists!
if [[ ! -f /boot/firmware/rpi-fake-pcr.bin ]]
then
    dd if=/dev/random of=/boot/firmware/rpi-fake-pcr.bin bs=32 count=5
fi

cp build/boot.scr.uimg /boot/firmware/
cp build/u-boot.bin /boot/firmware/
cp build/tpm-soft-spi.dtbo /boot/firmware/overlays/
