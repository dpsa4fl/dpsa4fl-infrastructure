#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Pushing images...'
docker push mxmurw/janus_server_aggregator
docker push mxmurw/janus_server_collect_jd
docker push mxmurw/janus_server_dpsa4fl-janus-tasks

