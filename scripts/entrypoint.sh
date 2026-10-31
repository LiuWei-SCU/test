#!/bin/bash
set -e
cd /opt/boofcv/BoofCV
if [ "$#" -eq 0 ]; then set -- bash; fi
exec "$@"
