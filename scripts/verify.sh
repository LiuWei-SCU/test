#!/bin/bash
set -euo pipefail
cd /opt/boofcv/BoofCV
mkdir -p /opt/boofcv/logs
run() { local name=$1; shift; ./gradlew "$@" --offline --no-daemon --console=plain --max-workers=2 2>&1 | tee "/opt/boofcv/logs/offline-$name.log"; }
run help help
# Clear generated build outputs so subsequent checks actually compile offline.
run clean clean
rm -f boofcv-v1.6.0.jar applications/applications.jar examples/examples.jar demonstrations/demonstrations.jar
run autogenerate autogenerate
run core oneJarBin
run applications :applications:applicationsJar
run examples :examples:examplesJar
run demonstrations :demonstrations:demonstrationsJar
