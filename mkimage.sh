#!/bin/bash

#mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr.rpi build/boot.scr
#mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr-tpm.rpi build/boot.scr.uimg

# Better to use flash-kernel to use placeholders and persist to update:
cp bootscr-tpm.rpi /etc/flash-kernel/bootscript/bootscr.rpi
flash-kernel
