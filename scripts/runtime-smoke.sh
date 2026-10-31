#!/bin/bash
set -euo pipefail
cd /opt/boofcv/BoofCV
mkdir -p /opt/boofcv/logs /opt/boofcv/smoke
java -jar applications/applications.jar | tee /opt/boofcv/logs/applications-start.log
grep -q CameraCalibrationMono /opt/boofcv/logs/applications-start.log
java -Djava.awt.headless=true -jar applications/applications.jar CreateCalibrationTarget -r 7 -c 5 -t CHESSBOARD -w 2 -o /opt/boofcv/smoke/chessboard > /opt/boofcv/logs/calibration-target.log 2>&1
test -s /opt/boofcv/smoke/chessboard.pdf
javac -d /opt/boofcv/smoke /opt/boofcv/scripts/LaunchProbe.java
xvfb-run -a java -cp examples/examples.jar:/opt/boofcv/smoke LaunchProbe boofcv.examples.ExampleLauncherApp | tee /opt/boofcv/logs/examples-launch.log
xvfb-run -a java -cp demonstrations/demonstrations.jar:/opt/boofcv/smoke LaunchProbe boofcv.DemonstrationLauncherApp | tee /opt/boofcv/logs/demonstrations-launch.log
javac -d /opt/boofcv/smoke /opt/boofcv/scripts/NativeProbe.java
java -cp examples/examples.jar:/opt/boofcv/smoke NativeProbe | tee /opt/boofcv/logs/native-ffmpeg.log
javac -d /opt/boofcv/smoke /opt/boofcv/scripts/NativePlatformsProbe.java
java -cp '/opt/boofcv/platform-deps/linux-x86_64/*:/opt/boofcv/smoke' NativePlatformsProbe | tee /opt/boofcv/logs/native-opencv-openblas.log
java -Djava.awt.headless=true -cp examples/examples.jar boofcv.examples.fiducial.ExampleQrCodeBinaryData | tee /opt/boofcv/logs/example-qr-roundtrip.log
grep -q 'Matched: true' /opt/boofcv/logs/example-qr-roundtrip.log
