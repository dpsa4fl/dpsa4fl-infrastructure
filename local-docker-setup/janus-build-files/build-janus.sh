#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function build
{
    BUILDKIT_PROGRESS=plain DOCKER_BUILDKIT=1 docker build "${SCRIPT_DIR}/../janus/" -f "${SCRIPT_DIR}/Dockerfile.dev" --build-arg BINARY=$1 -t janus_$1
}

build "aggregator"
build "collection_job_driver"
build "aggregation_job_driver"
build "aggregation_job_creator"
