let
  mkRustPkgs = { nixpkgs, system, rust-overlay }:
    let
      overlays = [ rust-overlay.overlays.default ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
    in
      pkgs;

  mkRustBuild = { pkgs, rust-toolchain, crane, crane-args }:
    let
      default-crate-lib = crane.mkLib pkgs;
      crane-lib = default-crate-lib.overrideToolchain rust-toolchain;

      crane-args-merged = crane-args // {
        strictDeps = true;
      };

      crane-and-cargo = crane-args-merged // {
        cargoArtifacts = crane-lib.buildDepsOnly crane-args;
      };

      build = crane-lib.buildPackage crane-and-cargo;
    in
      build;

  mkRustToolchain = { pkgs }:
    let
      rust-toolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain:
        toolchain.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        });
    in
      rust-toolchain;
in
{
  inherit mkRustToolchain;
  inherit mkRustBuild;
  inherit mkRustPkgs;

  mkRustOutput = { nixpkgs, system, rust-overlay, crane, crane-args }:
    let
      pkgs = mkRustPkgs { inherit nixpkgs system rust-overlay; };
      rust-toolchain = mkRustToolchain { inherit pkgs; };
      rust-build = mkRustBuild { inherit pkgs rust-toolchain crane crane-args; };
    in
    {
      inherit pkgs;
      buildInputs = [
        rust-build
        rust-toolchain
      ];
      build = rust-build;
    };
}
