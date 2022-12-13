#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Building images...'

# build aggregator
nix build '.?submodules=1#image_aggregator'
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" mxmurw/janus_server_aggregator:latest

# build collectJD
nix build '.?submodules=1#image_collect_jd'
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" mxmurw/janus_server_collect_jd:latest

# build aggregation JD
nix build '.?submodules=1#image_aggregation_jd'
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" mxmurw/janus_server_aggregation_jd:latest

# build aggregation JC
nix build '.?submodules=1#image_aggregation_jc'
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" mxmurw/janus_server_aggregation_jc:latest

# build dpsa4fl-janus-tasks
nix build '.?submodules=1#image_dpsa4fl-janus-tasks'
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" mxmurw/janus_server_dpsa4fl-janus-tasks:latest

