#![no_std]
#![no_main]
#![feature(asm)]
#![feature(abi_efiapi)]

// bring in the panic_halt-handlers
extern crate panic_halt;

use uefi::prelude::*;

#[entry] // expands to "no_mangle" and some more code
// the function must be named like this!
fn efi_main(_image_handler: uefi::Handle, system_table: SystemTable<Boot>) -> Status {
    loop {}
    Status::SUCCESS
}