BoofCV 1.6.0 完整 Linux Docker 开发镜像

Ubuntu 22.04.5 / linux/amd64 / Azul Java 25.0.5 / Gradle Wrapper 9.2.0。
BoofCV Commit: c6401d374de710a3a6904480717970573ad05b82。

下载三个 .part-00/01/02 文件及 Merge-Image.ps1，放在同一文件夹，执行：

```powershell
powershell -NoProfile -File .\Merge-Image.ps1
docker load -i boofcv-linux-amd64.tar.gz
docker run --rm -it boofcv:1.6.0
```

合并结果为真正的 docker-save gzip 归档，SHA-256：
5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab

核心库、Applications、Examples、Demonstrations 断网重编译通过；GUI 启动、PDF、二维码及 FFmpeg/OpenCV/OpenBLAS 验证通过；归档已实际 docker load 并离线运行验证。
Windows Docker Desktop 实机、真实相机、Android 构建未验证。完整日志和限制见 boofcv-build-materials.zip。
