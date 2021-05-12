#!/bin/bash

set -e

# QEMU mounts this dir as local FAT partition inside the VMs UEFI environment
QEMU_TO_IMG_DIR="./qemu-rt-img-direct"

rm -rf $QEMU_TO_IMG_DIR
mkdir -p "$QEMU_TO_IMG_DIR/EFI/BOOT"
cp "startup.nsh" "$QEMU_TO_IMG_DIR/"
# iff the file is called "EFI/BOOT/BOOTX64.EFI" it get's invoked automatically.
# This can be found in section 3.4.1.1 of
# https://uefi.org/sites/default/files/resources/UEFI_Spec_2_9_2021_03_18.pdf
cp "target/x86_64-unknown-uefi/debug/rust-hello-world-uefi-app.efi" "$QEMU_TO_IMG_DIR/EFI/BOOT/BOOTX64.EFI"

./_run_qemu.sh $QEMU_TO_IMG_DIR
