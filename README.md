# dpsa4fl testing infrastructure (custom janus server instance)

Infrastructure setup for running the [dpsa4fl example project](https://github.com/dpsa-project/dpsa4fl-example-project).

**NOTE**: setup for running janus for milestone 5 is now in the `run2` subdirectory.

## Run the server
Run `docker-compose` in the `run2` subdirectory.
```fish
~/dpsa4fl-testing-infrastructure/run> docker-compose up -d
```

## Building new images
When the janus source code changed, new docker images need to be built. This requires `nix`. To build, simply run the `run2/update.sh` script.
