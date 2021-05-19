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
  date = "2021-05-10";
  targets = [ ];
  chan = pkgs.rustChannelOfTargets channel date targets;
in chan
