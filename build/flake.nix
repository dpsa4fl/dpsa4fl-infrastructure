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
        rustbuild_janus = rustPlatform.buildRustPackage {
          pname =
            "janus_aggregator"; # make this what ever your cargo.toml package.name is
          version = "0.1.0";
          src = ./janus; # the folder with the cargo.toml
          cargoLock.lockFile = ./janus/Cargo.lock;
          cargoLock.outputHashes = {
            # "daphne-0.1.2" = "sha256-nYuTR0QjvlyWAVoSy1UmaPXZHco4KODxcNCDq4Vqcfo=";
            "prio-0.10.0" = "sha256-35rguMgtB64bDGKaDTiM8wYW4uK/TATAjLVQZOH8m/0=";
          };
          cargoBuildFlags = "-p janus_aggregator --features tokio-console";
          RUSTFLAGS = "--cfg tokio_unstable";
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [
            pkgs.openssl
          ];
          doCheck = false;
        };

        # # dpsa4fl-janus-tasks
        # rustbuild_dpsa4fl-janus-tasks = rustPlatform.buildRustPackage {
        #   pname =
        #     "dpsa4fl-janus-tasks"; # make this what ever your cargo.toml package.name is
        #   version = "0.1.0";
        #   src = ./dpsa4fl-janus-tasks; # the folder with the cargo.toml
        #   cargoLock.lockFile = ./dpsa4fl-janus-tasks/Cargo.lock;
        #   cargoLock.outputHashes = {
        #     "janus_aggregator-0.2.0" = "sha256-+mj6QwjfpAR92+0UoLJnnZGhKS4W66gELBNEHs86P/M=";
        #   };
        #   cargoBuildFlags = ""; #"-p janus_aggregator";
        #   nativeBuildInputs = [ pkgs.pkg-config ];
        #   buildInputs = [
        #     pkgs.openssl
        #   ];
        #   doCheck = false;
        # };

        ###########################################################
        # building the container
        #

        # aggregator
        dockerImage_aggregator = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_aggregator";
          config = {
            Cmd = [ "${rustbuild_janus}/bin/aggregator" "--config-file" "/data/aggregator-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

        # collect_jd
        dockerImage_collect_jd = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_collect_jd";
          config = {
            Cmd = [ "${rustbuild_janus}/bin/collect_job_driver" "--config-file" "/data/job-driver-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

        # aggregation_jd
        dockerImage_aggregation_jd = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_aggregation_jd";
          config = {
            Cmd = [ "${rustbuild_janus}/bin/aggregation_job_driver" "--config-file" "/data/job-driver-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

        # aggregation_jc
        dockerImage_aggregation_jc = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_aggregation_jc";
          config = {
            Cmd = [ "${rustbuild_janus}/bin/aggregation_job_creator" "--config-file" "/data/job-creator-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

        # dpsa4fl-janus-tasks
        dockerImage_dpsa4fl-janus-tasks = pkgs.dockerTools.buildLayeredImage {
          name = "mxmurw/janus_server_collect_jd";
          config = {
            Cmd = [ "${rustbuild_janus}/bin/dpsa4fl-janus-tasks" "--config-file" "/data/aggregator-config.yml" "--datastore-keys" "vWoEFA7F+ojcF+HohGLn/Q" ];
            WorkingDir = "/data";
            Volumes = { "/data" = {}; };
          };
        };

      in {
        packages = {
          rustPackage = rustbuild_janus;
          image_aggregator = dockerImage_aggregator;
          image_collect_jd = dockerImage_collect_jd;
          image_aggregation_jd = dockerImage_aggregation_jd;
          image_aggregation_jc = dockerImage_aggregation_jc;
          image_dpsa4fl-janus-tasks = dockerImage_dpsa4fl-janus-tasks;
        };
        defaultPackage = dockerImage_aggregator;

        devShell = pkgs.mkShell {
          buildInputs =
            [ (rustVersion.override { extensions = [ "rust-src" ]; }) ];
        };
      });

}
