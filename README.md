# dpsa4fl infrastructure

This repository provides the infrastructure setup required for using [dpsa4fl](../dpsa4fl). For an overview over the project see [here](../overview).

## local docker instance

See the README in the [`docker-test-setup`](./docker-test-setup) subfolder.

## distributed instance for deployment

See the README in the [`deployment-setup`](./deployment-setup) subfolder.

## Other


Infrastructure setup for running the [dpsa4fl example project](https://github.com/dpsa-project/dpsa4fl-example-project).

**NOTE**: The `run2` subdirectory contains git submodules, e.g. the janus setup. to clone this repo including all sumbodules, use

```
git clone --recursive https://github.com/dpsa-project/dpsa4fl-testing-infrastructure.git
```

## Run the server
Run `docker-compose` in the `run2` subdirectory.
```fish
~/dpsa4fl-testing-infrastructure/run> docker-compose up -d
```

## Building new images
When the janus source code changed, new docker images need to be built. This requires `nix`. To build, simply run the `run2/update.sh` script.
