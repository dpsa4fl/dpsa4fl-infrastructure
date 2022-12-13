#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Pushing images...'
docker push mxmurw/janus_server_aggregator
docker push mxmurw/janus_server_collect_jd
docker push mxmurw/janus_server_aggregation_jd
docker push mxmurw/janus_server_aggregation_jc
docker push mxmurw/janus_server_dpsa4fl-janus-tasks

