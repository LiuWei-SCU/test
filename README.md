# BoofCV 1.6.0 Linux Docker builder

此仓库用于交付已在云端实际构建的 BoofCV Docker 开发镜像。

镜像附件将放在 GitHub Releases 中，Release 标签：`boofcv-1.6.0-linux-amd64`。镜像超过单附件大小限制，因此分成三个卷；下载三个分卷及 `Merge-Image.ps1` 后合并，再执行 `docker load`。
**当前仓库提交本身不代表 Release 附件已上传，请以 Releases 页面实际附件为准。**

- Ubuntu 22.04.5 / linux/amd64
- Azul JDK 25.0.5（源码固定 Java 25 + Azul vendor）
- Gradle Wrapper 9.2.0
- BoofCV Commit: `c6401d374de710a3a6904480717970573ad05b82`
- 核心库、Applications、Examples、Demonstrations 已完成清理后断网重编译
- 已验证 GUI 启动、PDF、二维码往返及 FFmpeg/OpenCV/OpenBLAS
- 真实 Docker Archive 已通过 docker load 和重新加载后的离线 help
- Windows Docker Desktop 实机与真实相机未验证

原始归档：`boofcv-linux-amd64.tar.gz`，2238670915 bytes。
SHA-256：`5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab`。

本仓库不提交大型镜像二进制到 Git 历史；请使用 Release 附件。

## 从源码复现

仓库中的 Dockerfile、scripts/ 和报告均为构建材料；源代码和大文件在镜像内。
若需要重新在线构建，请将官方指定 Commit 的完整 BoofCV checkout（含 .git、origin/SNAPSHOT 引用与 data 子模块）放到 source/BoofCV，再按 Dockerfile 的临时 CA secret 说明执行。具体复现限制见 reports/BUILD_REPORT.md。
