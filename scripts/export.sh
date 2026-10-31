#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist logs
docker image inspect boofcv:1.6.0 > dist/image-inspect.json
docker run --rm --network none boofcv:1.6.0 ./gradlew help --offline --no-daemon > logs/final-offline-help.log 2>&1
docker run --rm --network none boofcv:1.6.0 ./gradlew oneJarBin :applications:applicationsJar :examples:examplesJar :demonstrations:demonstrationsJar --offline --no-daemon --console=plain --max-workers=2 > logs/final-image-offline-builds.log 2>&1
docker save boofcv:1.6.0 | gzip -1 > dist/boofcv-linux-amd64.tar.gz
gzip -t dist/boofcv-linux-amd64.tar.gz
tar -tzf dist/boofcv-linux-amd64.tar.gz > dist/archive-members.txt
grep -qx manifest.json dist/archive-members.txt
docker load -i dist/boofcv-linux-amd64.tar.gz > logs/docker-load.log 2>&1
docker run --rm --network none boofcv:1.6.0 ./gradlew help --offline --no-daemon > logs/reloaded-offline-help.log 2>&1
(cd dist && sha256sum boofcv-linux-amd64.tar.gz > SHA256SUMS.txt)
