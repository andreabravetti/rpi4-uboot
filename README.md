# rpi4-uboot

The purpose of this repository is not to securely enable TPM 2.0 on Raspberry PI 4, this is impossible without modifying the proprietary bootloader. What I want to accomplish is a configuration that allows the operating system to work as if it were on a system that fully supports TPM 2.0, for testing purposes.

A big thank you to https://github.com/joholl/rpi4-uboot-tpm which I used to start.

# Compile

## Original Ubuntu 22.04 boot.scr:

```
mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr.rpi boot.scr
```

## Customized Ubuntu 22.04 boot.scr with TPM "fake" support:

```
mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr-tpm.rpi boot.scr.uimg
```
