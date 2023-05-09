# Local docker instance for dpsa4fl

This file describes how to setup and start a local dpsa4fl infrastructure instance, consisting of two aggregation servers. With it, you can test differentially private, federated ML projects, such as our [example project](https://github.com/dpsa-project/dpsa4fl-example-project/), locally on your development machine.

## Requirements
The only requirement is a working `docker` installation. The build process itself runs inside a container.

## Downloading
To get all required files, you have to clone this repository. It contains git submodules, so the `--recursive` option has to be used to clone them as well:
```
git clone --recursive https://github.com/dpsa-project/dpsa4fl-infrastructure.git
```

## Building
Switch into the `local-docker-setup` subfolder. Inside, build all required docker images by running the following command:
```fish
~/dpsa4fl-infrastructure/local-docker-setup> ./build.sh
```
Docker will build all required janus server executables, this might take some minutes.

## Running
To start all required containers, use `docker-compose up`:
```fish
~/dpsa4fl-infrastructure/local-docker-setup> docker-compose up
```
To stop this infrastructure instance, run `docker-compose down`. This will remove all containers, volumes and networks created by the previous command.

## Updating
If you want to update to a new commmit of this repository, you have to also update the submodules. Thus, run:
```
git pull && git submodule update
```
After updating, you have to build all docker images again.


