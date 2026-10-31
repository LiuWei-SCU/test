#!/bin/bash
set -euo pipefail
cd /opt/boofcv/BoofCV
cp "$JAVA_HOME/lib/security/cacerts" /tmp/build-cacerts
keytool -importcert -noprompt -alias session-proxy -file /run/secrets/proxy_ca -keystore /tmp/build-cacerts -storepass changeit
proxy=${HTTPS_PROXY:-${https_proxy:-}}; proxy=${proxy#*://}; proxy=${proxy%%/*}; proxy=${proxy##*@}
host=${proxy%:*}; port=${proxy##*:}
export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=/tmp/build-cacerts -Djavax.net.ssl.trustStorePassword=changeit -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port -Dhttp.proxyHost=$host -Dhttp.proxyPort=$port"
./gradlew --no-daemon --console=plain --max-workers=2 "$@"
rm -f /tmp/build-cacerts
