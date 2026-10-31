# Windows Docker Desktop

Cloud performs the build. Windows only loads and runs the resulting archive.
Use Docker Desktop in Linux containers mode with the WSL2 backend, x86_64 Windows 10/11.

```powershell
Get-FileHash .\boofcv-linux-amd64.tar.gz -Algorithm SHA256
docker load -i .\boofcv-linux-amd64.tar.gz
docker image inspect boofcv:1.6.0 --format '{{.Os}}/{{.Architecture}}'
docker run --rm --network none boofcv:1.6.0 ./gradlew help --offline --no-daemon
docker run --rm -it boofcv:1.6.0
```

The source working directory is `/opt/boofcv/BoofCV`; Gradle cache is `/opt/gradle-cache`.
Do not mount over either directory: doing so would hide the packaged files.
Run `/opt/boofcv/scripts/verify.sh` to repeat offline compilation. No host Java or Gradle is required.
The image uses Linux native libraries. Windows Docker Desktop runs these inside its Linux VM.
For Windows-native Java processes, use Windows x86_64 native classifiers separately; Linux `.so` files cannot replace Windows DLLs.
GUI launchers require an X server and DISPLAY configuration, or the bundled Xvfb for noninteractive checks.
Actual Windows Desktop and physical camera tests must be recorded as unverified until executed on that platform.
No local Clash configuration is needed for offline operation; online proxies must be configured explicitly and preserve TLS trust.

## Optional native Windows development artifacts

`maven-repository.zip` contains the actual downloaded POM/JAR/module files in Maven repository layout, including separate platform classifiers. Extract into a dedicated directory and select it as Maven's local repository (for example `-Dmaven.repo.local=C:\boofcv-m2`). This is a cache of the selected build's artifacts, not a verified complete Windows build environment.
`windows-x86_64-native.zip` contains Windows JavaCPP, FFmpeg, OpenCV and OpenBLAS dependencies. Use their corresponding pure Java APIs and transitive dependencies from the Maven archive.
`pure-java-dependencies.zip` includes JARs without `.dll`, `.so`, `.dylib`, or `.jnilib` resources found by inventory scanning. It includes build-tool JARs as well as application dependencies; it is not a single application classpath.
Upstream universal JARs (JNA, BridJ, WebcamCapture, Byte Buddy, Kotlin/Gradle tooling) can bundle foreign-platform resources. They are preserved unmodified; runtime probes explicitly load Linux native libraries. No Windows execution is claimed.
