# Almost fake, but usable, TPM2.0 support for Raspberry PI 4

The purpose of this repository is not to securely enable TPM 2.0 on Raspberry PI 4, this is impossible without modifying the proprietary bootloader. What I want to accomplish is a configuration that allows the operating system to work as if it were on a system that fully supports TPM 2.0, for testing purposes.

That said:

- PCRs from 0 to 3 and PCR6 are completely faked with random data, stored per device to preserve it.
- PCR4, PCR5, and PCR7 may be almost fine, even if not sure about it and it's not the purpose of this work.
- PCR8 and PCR9 are extended by this u-boot script and this part could be taken as a starting point for a real implementation even if, right now, it's not to be trusted without any real measurement from previous stages.

A big thank you to https://github.com/joholl/rpi4-uboot-tpm which I used to start.

## Compile

You can compile u-boot 2200.10 with the .config in u-boot/config.

There is a prebuilt "u-boot.bin" image in build/.

Now you can "compile" the customized Ubuntu 22.04 bootscr.rpi with TPM "fake" support:

```
mkimage -A arm64 -T script -C none -n "Boot script" -d bootscr-tpm.rpi boot.scr.uimg
```

There is a prebuilt "boot.scr.uimg" image in build/.

You can compile the tpm-soft-spi.dts overlays with:

```
dtc -O dtb -b 0 -@ overlays/tpm-soft-spi.dts -o tpm-soft-spi.dtbo
```

There is a prebuilt "tpm-soft-spi.dtbo" image in build/.

## Decompile from scr to script with:

```
dd if=boot.scr of=boot.source.scr bs=72 skip=1
```

## Generate fake data for initial PCRs:

```
dd if=/dev/random of=/boot/firmware/rpi-fake-pcr.bin bs=32 count=5
```

## Results

```
root@despico:~# uname -a
Linux despico 5.15.0-1017-raspi #19-Ubuntu SMP PREEMPT Fri Oct 14 08:22:47 UTC 2022 aarch64 aarch64 aarch64 GNU/Linux

root@despico:~# cat /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy

root@despico:~# tpm2_pcrread | tail -n 25
  sha256:
    0 : 0xD2529E0DBA625900D4555E573FFA764316C65E03EB22B1DF4BDF3C2339FF29B6
    1 : 0xBB0F5AAD17E5BEAB688F793FB8B3A8CCBF298ADC85F52BB7A4377B2DC0770DB7
    2 : 0xF17C27FA370344579FE74A43C9005D979C578790C08F5C0B8D0B081FD6B9C29D
    3 : 0x22763C065ABFA01A2A473C8D7572460F6C0FAE66115AB909809216BB3FAFEA5F
    4 : 0x8B9D67E23DB9DB181E079D02340860C7651A572623217FA51FB20B4BE2A9E660
    5 : 0x282C245808ABCD99589CFCB6C44859B77EC36BC04BC5FE2EB60BF4C9BA5D8086
    6 : 0x33D1A74F5AABB973382E7CCD7659DEBA4637FF8D275162811EE6723B744569B2
    7 : 0x9D2A6134DF542A2C0E05E91C7A8928384D6EABA71E9852BE63BB01169C6EA6CF
    8 : 0x0FFD2CB1D64921EBD554604C38306BE740A5160EB46A25E49700E8A83017FD5A
    9 : 0x0EC5ACD84CB357FD5CE6D4CC9A877EA6245EB64E73AC42A38AD256067A49EB17
    10: 0x0000000000000000000000000000000000000000000000000000000000000000
    11: 0x0000000000000000000000000000000000000000000000000000000000000000
    12: 0x0000000000000000000000000000000000000000000000000000000000000000
    13: 0x0000000000000000000000000000000000000000000000000000000000000000
    14: 0x0000000000000000000000000000000000000000000000000000000000000000
    15: 0x0000000000000000000000000000000000000000000000000000000000000000
    16: 0x0000000000000000000000000000000000000000000000000000000000000000
    17: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    18: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    19: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    20: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    21: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    22: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    23: 0x0000000000000000000000000000000000000000000000000000000000000000
```

## Note

On ubuntu the default boot script is boot.scr, but boot.scr.uimg prevail if present.

You need to use boot.scr.uimg else flash-kernel will overwrite your file with defaults.
