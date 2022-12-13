#!/usr/bin/env bash
set -e; set -o pipefail;

echo "starting jaeger..."

docker run -d -p6831:6831/udp -p6832:6832/udp -p16686:16686 -p14268:14268 jaegertracing/all-in-one:latest

