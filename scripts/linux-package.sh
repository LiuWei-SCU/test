#!/bin/bash
set -euo pipefail
cd /opt/boofcv/BoofCV
# Gradle's documented native_arch property constrains optional platform variants.
export ORG_GRADLE_PROJECT_native_arch=linux-x86_64
find /opt/gradle-cache/caches/modules-2/files-2.1/org.bytedeco -type f \( -name '*-windows-x86_64.jar' -o -name '*-macosx-arm64.jar' -o -name '*-linux-arm64.jar' \) -print -delete > /opt/boofcv/logs/removed-platform-classifiers.log
./gradlew :applications:applicationsJar :examples:examplesJar :demonstrations:demonstrationsJar --offline --no-daemon --console=plain --max-workers=2 2>&1 | tee /opt/boofcv/logs/offline-linux-jars.log
/opt/boofcv/scripts/runtime-smoke.sh
