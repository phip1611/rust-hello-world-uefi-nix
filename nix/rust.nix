# nix/rust.nix
{ sources ? import ./sources.nix }:

let
  pkgs = import sources.nixpkgs { overlays = [ (import sources.nixpkgs-mozilla) ]; };
  # downloads rust as tarball from
  # https://static.rust-lang.org/dist/<date>/rust-<version>-<target-triplet>.tar.xz
  # - https://static.rust-lang.org/dist/<date> itself returns an index
  # - the nix build process automatically takes the right version
  #   and arch/compiler target triplet

  #channel = "stable";
  channel = "nightly";

  # This is the earliest release day of rust nightly, where cargo doesn't add the
  # "release = 3" to Cargo.toml - this is required for nix/naersk as long as
  # https://github.com/nmattia/naersk/issues/176 is not resolved.
  #
  # It will install rustc 1.51.0-nightly and cargo 1.50.0-nightly.
  #
  # To install the versions locally, execute:
  # $ rustup default nightly-2020-12-31      (nightlys are not versioned, therefore you have to use the date)
  date = "2020-12-31";
  targets = [ ];
  chan = pkgs.rustChannelOfTargets channel date targets;
in chan
