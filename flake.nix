{
  description = "Personal tools.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, crane  }:
    let
      tt = import ./nix/tt.nix;
      systems = flake-utils.lib.eachDefaultSystem (system:
        let
          crane-args = {
            pname = "tt";
            version = "0.1.0";
            src = ./tt;
          };

          tt-output = tt.mkRustOutput { inherit nixpkgs system rust-overlay crane crane-args; };
        in
        {
          devShells.default = tt-output.pkgs.mkShell {
            buildInputs = tt-output.buildInputs;
          };

          packages.default = tt-output.build;
        });

      output = systems // {
        cheese = tt;
      };
    in
      output;
    }
