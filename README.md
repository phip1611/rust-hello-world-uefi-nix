# Task: Hello World UEFI Application

## ⚠ Important Build Notice ⚠   
This project was built/tested with `rustc 1.51.0-nightly`/`cargo 1.50.0-nightly` because
* it uses the unstable `build-std`-feature to cross-compile the core library for the UEFI target.
* Nix/naersk doesn't work with `Cargo.lock`-files from newer Cargo versions than the one specified above,
  see https://github.com/nmattia/naersk/issues/176
* to use the specific version locally (which is not necessarily required because of Nix)
  execute: \ 
  `$ rustup default nightly-2020-12-31`

## About this repo
This repository consists of:
- a "hello world"-UEFI-Application written in Rust called `rust-hello-world-uefi-app.efi`
- a `build.sh` file that:
  - expects a valid path to `tianocore/edk2` (configurable inside the script)
  - builds the `OVMF`-package inside `edk2`
  - builds the EFI executable
- two run scripts
  - both require you to run `build.sh` at least once beforehand
  - a `run-startup-nsh.sh` file that:
    - starts `startup.nsh` inside the UEFI environment inside QEMU (--> EFI shell script, that starts the Rust UEFI app)
  - a `run-direct.sh` file that:
    - starts the Rust UEFI application inside the UEFI environment inside QEMU directly
    - this works, because the file is stored as `\EFI\BOOT\BOOT{xx:ARCH}.EFI`
    - a bootloader will execute this file automatically, if it is present on a drive
      (e.g. OS system installer as EFI application on a USB drive)

## Prerequisites for building
### Clone EDK2 (which contains OVMF-package sources) into your system
You need this for the firmware image that should be loaded into QEMU later.
- `$ git clone https://github.com/tianocore/edk2.git`
- `$ cd edk2`
- `$ git submodule update --init`
### Build EDK2/OVMF-package
- install at least the following packages (package names for Ubuntu, might be different on your system)
    - `$ sudo apt install nasm iasl build-essential uuid-dev`
    - `uuid-dev` package contains `libuuid`
- **build.sh can build EDK2/OVMF when you followed the steps here once successfully!**
- build the support tools/modules first (as stated here https://wiki.ubuntu.com/UEFI/EDK2)
    - make sure that `$ python` is available!
      - if not: `$ ln -s /usr/bin/python3 /usr/bin/python`
    - `$ make -C BaseTools`
    - if something fails, probably a package is missing, check error log and install the package
- now change some keys inside `<edk2-root>/Conf/target.txt` to have the values as specified below
  (values taken from https://github.com/tianocore/tianocore.github.io/wiki/How-to-build-OVMF)
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

## Trivia for target `x86_64-unknown-uefi`
- RFC: https://github.com/rust-lang/rust/pull/56769/files
- Merge of the target into Rust (2018-12-13): 
  https://github.com/rust-lang/rust/commit/88cf2a23e24cdbf7a134d14185c1e5b69ffd07c3  
- (UEFI) ABI is mostly similar to windows -> target implementation was relatively easy
- currently, core library must be cross compiled using the unstable feature
  `build-std` of cargo (therefore rust nightly us used)
- as of May 2021 (rustc 1.54.0-nightly) there is no installable target
  available, i.e. `rustup target add x86_64-unknown-uefi` will do nothing
  --> reason to cross compile

## Interesting links
- https://github.com/rust-osdev/uefi-rs

