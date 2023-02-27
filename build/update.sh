#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Updating...'

cd janus
git pull origin dpsa-m4-release
cd ..
./build-janus-image.sh
./push-janus-image.sh


