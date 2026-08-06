{
  description = "Personal tools.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, crane }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rust_toolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain:
          toolchain.default.override {
            extensions = [ "rust-src" "rust-analyzer" ];
          });

        default_crate_lib = crane.mkLib pkgs;
        crane_lib = default_crate_lib.overrideToolchain rust_toolchain;

        crane_args = {
          pname = "tt";
          version = "0.1.0";

          src = ./tt;

          strictDeps = true;
        };

        crane_and_cargo = crane_args // {
          cargoArtifacts = crane_lib.buildDepsOnly crane_args;
        };

        tt_build = crane_lib.buildPackage crane_and_cargo;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            rust_toolchain
            tt_build
          ];
        };

        packages.default = tt_build;
      });
}
