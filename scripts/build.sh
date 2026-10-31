#!/bin/bash
set -euo pipefail
cd /opt/boofcv/BoofCV
mkdir -p /opt/boofcv/logs
run() { local name=$1; shift; ./gradlew --no-daemon --console=plain --max-workers=2 "$@" 2>&1 | tee "/opt/boofcv/logs/$name.log"; }
run version --version
run tasks tasks --all
run autogenerate autogenerate
run core oneJarBin
run applications :applications:applicationsJar
run examples :examples:examplesJar
run demonstrations :demonstrations:demonstrationsJar
