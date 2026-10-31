#!/bin/bash
set -euo pipefail
cd /opt/boofcv/BoofCV
cat /etc/os-release
uname -m
java -version
test "$(git rev-parse HEAD)" = c6401d374de710a3a6904480717970573ad05b82
git diff --exit-code
test -s gradle/wrapper/gradle-wrapper.jar
test -d /opt/gradle-cache/caches/modules-2/files-2.1
for jar in boofcv-v1.6.0.jar applications/applications.jar examples/examples.jar demonstrations/demonstrations.jar; do test -s "$jar"; done
test ! -e /tmp/build-cacerts
./gradlew help --offline --no-daemon --console=plain --max-workers=2
