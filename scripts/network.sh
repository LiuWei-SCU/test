#!/bin/bash
set -uo pipefail
for url in https://repo.maven.apache.org/maven2/ https://plugins.gradle.org/m2/ https://plugins-artifacts.gradle.org/ https://services.gradle.org/ https://dl.google.com/dl/android/maven2/ https://registry-1.docker.io/v2/; do
 echo "=== $url ==="
 curl --connect-timeout 15 --max-time 45 -I "$url"
 echo "curl_exit=$?"
done
