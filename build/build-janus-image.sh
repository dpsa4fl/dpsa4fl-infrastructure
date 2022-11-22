#!/usr/bin/env bash
set -e; set -o pipefail;
nix build '.?submodules=1#image_aggregator'
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" mxmurw/janus_server_aggregator:latest
