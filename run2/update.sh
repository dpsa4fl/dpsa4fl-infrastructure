#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Updating...'

cd janus
git pull origin dpsa-m4-release
cd ..

cd dpsa4fl-janus-tasks
git pull origin main
cd ..

docker-compose build

