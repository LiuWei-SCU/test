#!/bin/bash
set -euo pipefail
container=${1:-boofcv-build-work}
# Flatten the stopped container filesystem; bind-mounted CA contents are excluded by Docker export.
docker export "$container" | docker import --platform linux/amd64 \
 --change 'ENV JAVA_HOME=/usr/lib/jvm/zulu25-ca-amd64 GRADLE_USER_HOME=/opt/gradle-cache ORG_GRADLE_PROJECT_native_arch=linux-x86_64 LANG=C.UTF-8 HOME=/root' \
 --change 'ENV PATH=/usr/lib/jvm/zulu25-ca-amd64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
 --change 'WORKDIR /opt/boofcv/BoofCV' \
 --change 'ENTRYPOINT ["/opt/boofcv/scripts/entrypoint.sh"]' \
 --change 'CMD ["bash"]' \
 --change 'LABEL org.opencontainers.image.source=https://github.com/lessthanoptimal/BoofCV org.opencontainers.image.revision=c6401d374de710a3a6904480717970573ad05b82 org.opencontainers.image.version=1.6.0' \
 - boofcv:1.6.0
