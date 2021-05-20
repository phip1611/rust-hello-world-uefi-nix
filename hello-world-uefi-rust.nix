{ sources ? import ./nix/sources.nix, pkgs ? import sources.nixpkgs {}}:
let
  # import rust compiler
  rust = import ./nix/rust.nix { inherit sources; };

  # add sources to rust
  # (don't know yet how to do this in ./nix/rust.nix)
  rustWithSrc = rust.override {
    extensions = [ "rust-src" ];
  };

  # configure naersk to use our pinned rust compiler
  naersk = pkgs.callPackage sources.naersk {
    rustc = rustWithSrc;
    cargo = rustWithSrc;
  };

  # tell nix-build to ignore the `target` directory
  src = builtins.filterSource(path: type: type != "directory" || builtins.baseNameOf path != "target") ./.;
in {
   # for playing around in nix repl
   # in nix repl: "x = import ./hello-world-uefi-rust.nix {  }"
   # -> x.rust => see attributes
   inherit rust;
   # inherit rustWithSrc;

   pkg = naersk.buildPackage {
      inherit src;
      # concat existing options with our custom options
      # we input a lambda: `x -> x combined with second list
      cargoBuildOptions = inputList: inputList ++ ["--target" "x86_64-unknown-uefi"];
      remapPathPrefix = true; # remove nix store references for a smaller output package.
    };
}