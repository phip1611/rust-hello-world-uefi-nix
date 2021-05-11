#!/bin/bash

set -e

RUST_BUILD_DIR="./build"
EDK2_REPOSITORY_PATH="../edk2"
OVMF_BUILD_ARTIFACT_PATH="${EDK2_REPOSITORY_PATH}/Build/OvmfX64/DEBUG_GCC5/FV"
OVMF_FW_PATH="${OVMF_BUILD_ARTIFACT_PATH}/OVMF.fd"
OVMF_VARS_PATH="${OVMF_BUILD_ARTIFACT_PATH}/OVMF_VARS.fd"
# final binary names
OVMF_FW="ovmf_uefi.img"
OVMF_VARS="ovmf_uefi_vars.img"

echo "${OVMF_FW_PATH}"
echo "${OVMF_VARS_PATH}"

RED="\e[31m"
BOLD="\e[1m"
RESET="\e[0m"

# main allows us to move all function definitions to the end of the file
main() {

  QEMU_ARGS=(
        # Disable default devices
        # QEMU by default enables a ton of devices which slow down boot.
        "-nodefaults"

        # Use a standard VGA for graphics
        "-vga"
        "std"

        # Use a modern machine, with acceleration if possible.
        "-machine"
        "q35,accel=kvm:tcg"

        # Allocate some memory
        "-m"
        "128M"

        # Set up OVMF
        "-drive"
        "if=pflash,format=raw,readonly,file=${OVMF_FW_PATH}"
        "-drive"
        "if=pflash,format=raw,file=${OVMF_VARS_PATH}"

        # Mount a local directory as a FAT partition
        "-drive"
        "format=raw,file=fat:rw:${RUST_BUILD_DIR}"

        # Enable serial
        #
        # Connect the serial port to the host. OVMF is kind enough to connect
        # the UEFI stdout and stdin to that port too.
        "-serial"
        "stdio"

        # Setup monitor
        "-monitor"
        "vc:1024x768"
  )

  # echo "qemu-system-x86_64 ${QEMU_ARGS[@]}"
  qemu-system-x86_64 "${QEMU_ARGS[@]}"


}

################## all function definitions ##################



# call main
main
