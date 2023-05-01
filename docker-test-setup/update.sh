#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Updating...'

cd janus
git pull
cd ..

cd dpsa4fl-janus-tasks
git pull
cd ..

docker-compose build

