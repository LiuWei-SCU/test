# GitHub 镜像交付

已使用正常 Git HTTPS 代理将现成镜像拆为 43 个小分卷上传至 boofcv-image-1.6.0 分支，未重新构建镜像。
前 42 个分卷各 52428800 bytes，最后一个 36661315 bytes；合计 2238670915 bytes。
分卷顺序 000 至 042，拼接后的 SHA-256 已在云端验证为 5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab。
每个分卷的 SHA-256 见 image/SHA256SUMS.txt。Git 推送成功后，以远端分支提交与本地提交一致验证上传完成。
下载：https://github.com/LiuWei-SCU/test/archive/refs/heads/boofcv-image-1.6.0.zip
ZIP 解压后运行 Merge-Git-Image.ps1，得到真正 Docker Archive，再 docker load。
此方式在仓库 Git 数据中保存约 2.1 GiB 镜像；未使用 Release API，未创建 Release 附件。
