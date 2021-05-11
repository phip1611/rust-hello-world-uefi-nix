# Task: Hello World UEFI Application

## Prerequisites
### Clone EDK2 (which contains OVMF-package sources)
- `$ git clone https://github.com/tianocore/edk2.git`
- `$ cd edk2`
- `$ git submodule update --init`
### Build EDK2/OVMF-package (to be able to boot an UEFI in Qemu later)
- install at least the following packages (package names for Ubuntu, might be different for your environment)
    - `$ sudo apt install nasm iasl build-essential`
- **build.sh can build EDK2/OVMF when you followed the steps here once successfully!**
- build the support tools/modules first (as stated here https://wiki.ubuntu.com/UEFI/EDK2)
    - make sure that "python" is available!
      - else: `$ ln -s /usr/bin/python3 /usr/bin/python`
    - `$ make -C BaseTools`
    - if something fails, probably a package is missing, check error log and install the package
- now change `<edk2-root>/Conf/target.txt` to follow the steps specified here:
  - https://github.com/tianocore/tianocore.github.io/wiki/How-to-build-OVMF
  - basically just make sure the following vars have the proper value
  - ```
    ACTIVE_PLATFORM       = OvmfPkg/OvmfPkgX64.dsc
    TARGET_ARCH           = X64
    TOOL_CHAIN_TAG        = GCC5
    ```  
- in `<edk2-root>/OvmfPkg` execute: \
  `$ ./build.sh`
  - if something fails, probably a package is missing, check error log and install the package
### Prepare everything for **QEMU**
- `$ sudo apt install qemu qemu--kvm`

## Interesting links
- https://gil0mendes.io/blog/an-efi-app-a-bit-rusty/
- https://github.com/rust-osdev/uefi-rs

