#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Updating...'

cd janus
git pull
cd ..
./build-janus-image.sh
./push-janus-image.sh


