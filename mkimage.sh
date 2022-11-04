#!/bin/bash

#mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr.rpi build/boot.scr
#mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr-tpm.rpi build/boot.scr.uimg

set -e

FK_DIR="/usr/share/flash-kernel"

. "${FK_CHECKOUT:-$FK_DIR}/functions"

mkimage_script "boot" "script" "bootscr-tpm.rpi" "build/boot.scr.uimg"

