#![no_std]
#![no_main]
// allow inline assembly
#![feature(asm)]
// compile target with efi abi calling convention
#![feature(abi_efiapi)]

extern crate alloc;

use uefi::prelude::*;
use log::info;
use alloc::string::ToString;

#[entry] // expands to "no_mangle" and some more code
// the function must be named like this!
fn efi_main(_image_handler: uefi::Handle, system_table: SystemTable<Boot>) -> Status {
    // - inits "halt on panic"
    // - inits a logger, then we can use "log" crate including formatting!
    uefi_services::init(&system_table).expect_success("Failed to initialize utils");
    info!("This output comes from the Hello World UEFI-App written in Rust.");
    info!("Firmware Version: {:?}", system_table.firmware_revision());
    info!("Firmware Vendor : {}", system_table.firmware_vendor().to_string());
    loop {}
    Status::SUCCESS
}
