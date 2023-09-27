#!/usr/bin/env bash
set -e; set -o pipefail;

echo 'Updating...'

cd janus
git pull
cd ..

cd dpsa4fl
git pull
cd ..

