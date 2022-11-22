{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustVersion = pkgs.rust-bin.stable.latest.default;
        rustPlatform = pkgs.makeRustPlatform {
          cargo = rustVersion;
          rustc = rustVersion;
        };

        # janus_server
        myRustBuild = rustPlatform.buildRustPackage {
          pname =
            "janus_aggregator"; # make this what ever your cargo.toml package.name is
          version = "0.1.0";
          src = ./janus; # the folder with the cargo.toml
          cargoLock.lockFile = ./janus/Cargo.lock;
          cargoLock.outputHashes = {
            "daphne-0.1.2" = "sha256-nYuTR0QjvlyWAVoSy1UmaPXZHco4KODxcNCDq4Vqcfo=";
          };
          cargoBuildFlags = "-p janus_aggregator";
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [
            pkgs.openssl
          ];
          doCheck = false;
        };

        # building the container
        dockerImage_aggregator = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_aggregator";
          config = {
            Cmd = [ "${myRustBuild}/bin/aggregator" "--config-file" "/data/aggregator-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

        dockerImage_collectJD = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_collectJD";
          config = {
            Cmd = [ "${myRustBuild}/bin/collect_job_driver" "--config-file" "/data/aggregator-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

      in {
        packages = {
          rustPackage = myRustBuild;
          image_aggregator = dockerImage_aggregator;
          image_collectJD = dockerImage_collectJD;
        };
        defaultPackage = dockerImage_aggregator;

        devShell = pkgs.mkShell {
          buildInputs =
            [ (rustVersion.override { extensions = [ "rust-src" ]; }) ];
        };
      });

}
