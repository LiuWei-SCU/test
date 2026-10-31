#!/bin/bash
set -euo pipefail
cp "$JAVA_HOME/lib/security/cacerts" /tmp/build-cacerts
keytool -importcert -noprompt -alias session-proxy -file /run/secrets/proxy_ca -keystore /tmp/build-cacerts -storepass changeit
export CURL_CA_BUNDLE=/run/secrets/ca_bundle
proxy=${HTTPS_PROXY:-${https_proxy:-}}
proxy=${proxy#*://}; proxy=${proxy%%/*}; proxy=${proxy##*@}
host=${proxy%:*}; port=${proxy##*:}
export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=/tmp/build-cacerts -Djavax.net.ssl.trustStorePassword=changeit -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port -Dhttp.proxyHost=$host -Dhttp.proxyPort=$port"
mkdir -p /opt/boofcv/logs
/opt/boofcv/scripts/network.sh | tee /opt/boofcv/logs/network.log
/opt/boofcv/scripts/build.sh
rm -f /tmp/build-cacerts
