echo "startup.nsh will start the Rust UEFI application now:"
echo "the name \"startup.nsh\" is by convention automatically executed"
echo "you can find info about it inside 'UEFI_Shell_Spec_2_0'"
echo "this will NOT be invoked, when a '\EFI\BOOT\BOOT{XX:ARCH}.EFI' file is found"

\foobar\rust-hello-world-uefi-app.efi
