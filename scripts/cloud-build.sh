#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
test "$(git -C source/BoofCV rev-parse HEAD)" = c6401d374de710a3a6904480717970573ad05b82
git -C source/BoofCV show-ref --verify refs/remotes/origin/SNAPSHOT >/dev/null
: "${CODEX_PROXY_CERT:?Managed cloud proxy CA path is required}"
mkdir -p logs reports dist
docker build --platform linux/amd64 --target base --secret id=ca_bundle,src=/etc/ssl/certs/ca-certificates.crt --progress plain -t boofcv-base:1.6.0 . 2>&1 | tee logs/base-rebuild.log
container=boofcv-build-work
# Refuse to overwrite an existing build container.
if docker container inspect "$container" >/dev/null 2>&1; then echo "Existing $container; preserve or remove it explicitly before a new build" >&2; exit 1; fi
docker run -d --name "$container" -e ORG_GRADLE_PROJECT_native_arch=linux-x86_64 \
 --mount type=bind,src=/etc/ssl/certs/ca-certificates.crt,dst=/run/secrets/ca_bundle,readonly \
 --mount "type=bind,src=$CODEX_PROXY_CERT,dst=/run/secrets/proxy_ca,readonly" boofcv-base:1.6.0 sleep infinity
docker cp scripts/. "$container":/opt/boofcv/scripts/
docker exec "$container" bash -c 'set -e; chown -R root:root /opt/boofcv/BoofCV; chmod +x /opt/boofcv/scripts/*.sh; /opt/boofcv/scripts/online-build.sh; /opt/boofcv/scripts/trusted-gradle.sh -I /opt/boofcv/scripts/platform-deps.init.gradle collectPlatformDependencies -PbundlePlatform=linux-x86_64' 2>&1 | tee logs/online-rebuild.log
docker network disconnect bridge "$container"
docker exec "$container" bash -c 'set -e; /opt/boofcv/scripts/verify.sh; /opt/boofcv/scripts/runtime-smoke.sh' 2>&1 | tee logs/disconnected-rebuild.log
docker stop "$container"
bash scripts/seal-image.sh "$container"
bash scripts/export.sh
