# syntax=docker/dockerfile:1
FROM azul/zulu-openjdk:25-latest@sha256:96298e33de6950e933cec3eb83cedebc954e1f9545ca990efca4c6cf1dbe1e43 AS base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Public CA bundle supplied transiently; no session-specific trust is retained.
RUN --mount=type=secret,id=ca_bundle,required=true \
    export SSL_CERT_FILE=/run/secrets/ca_bundle CURL_CA_BUNDLE=/run/secrets/ca_bundle && \
    apt-get -o Acquire::https::CaInfo=/run/secrets/ca_bundle update && \
    DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::https::CaInfo=/run/secrets/ca_bundle install -y --no-install-recommends git curl unzip ca-certificates build-essential libxext6 libxrender1 libxtst6 libxi6 libgl1 libglib2.0-0 libasound2 xvfb xauth && \
    rm -rf /var/lib/apt/lists/*
ENV GRADLE_USER_HOME=/opt/gradle-cache
WORKDIR /opt/boofcv/BoofCV
COPY source/BoofCV/ ./
COPY scripts/ /opt/boofcv/scripts/
RUN chmod +x /opt/boofcv/scripts/*.sh
FROM base AS builder
ENV ORG_GRADLE_PROJECT_native_arch=linux-x86_64
RUN --mount=type=secret,id=ca_bundle,required=true --mount=type=secret,id=proxy_ca,required=true \
    /opt/boofcv/scripts/online-build.sh && \
    /opt/boofcv/scripts/trusted-gradle.sh -I /opt/boofcv/scripts/platform-deps.init.gradle collectPlatformDependencies -PbundlePlatform=linux-x86_64
RUN --network=none /opt/boofcv/scripts/verify.sh
RUN --network=none /opt/boofcv/scripts/runtime-smoke.sh
COPY reports/ /opt/boofcv/reports/
ENV HTTP_PROXY="" HTTPS_PROXY="" http_proxy="" https_proxy="" NO_PROXY="" no_proxy=""
ENTRYPOINT ["/opt/boofcv/scripts/entrypoint.sh"]
CMD ["bash"]
