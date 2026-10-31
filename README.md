# BoofCV 1.6.0 Linux Docker 镜像交付

已实际构建并验证的完整 Docker 镜像存放在 `boofcv-image-1.6.0` 分支，分成 43 个小分卷。main 分支仅保存说明与构建材料。请使用下方指定分支的 ZIP 下载链接。

## 下载与加载

1. 下载本分支 ZIP： https://github.com/LiuWei-SCU/test/archive/refs/heads/boofcv-image-1.6.0.zip
2. 解压 ZIP，在解压目录中打开 PowerShell。
3. 执行 Merge-Git-Image.ps1，将 43 个分卷按二进制方式合并；脚本自动检查最终 SHA-256。
4. 执行：

```powershell
.\Merge-Git-Image.ps1
docker load -i boofcv-linux-amd64.tar.gz
docker run --rm -it boofcv:1.6.0
```

也可以 git clone --branch boofcv-image-1.6.0 --single-branch https://github.com/LiuWei-SCU/test.git 获取本分支。
此 ZIP 是分卷交付包，不能直接 docker load；合并后的 boofcv-linux-amd64.tar.gz 才是真正 Docker Archive。
私有仓库需要先在浏览器登录有访问权限的 GitHub 账号。

## 镜像信息

- Ubuntu 22.04.5 / linux/amd64
- Azul Java 25.0.5 / Gradle Wrapper 9.2.0
- BoofCV Commit: c6401d374de710a3a6904480717970573ad05b82
- 原始归档大小：2238670915 bytes
- 原始归档 SHA-256：5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab
- 核心库、Applications、Examples、Demonstrations 已完成清理后断网重编译
- 已实际验证 GUI 启动、PDF、二维码和 FFmpeg/OpenCV/OpenBLAS
- 已实际 docker load 并验证重新加载后的离线 help
- Windows Docker Desktop 实机、真实相机、Android 构建未验证

说明：因云端 Release API 被网络策略拦截，使用已授权的 Git 通道交付。本分支约增加 2.1 GiB Git 数据；完整性验证请使用 image/SHA256SUMS.txt 和上面的最终归档 SHA-256。
