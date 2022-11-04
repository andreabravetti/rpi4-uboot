#!/bin/bash

mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr.rpi build/boot.scr
mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr-tpm.rpi build/boot.scr.uimg

