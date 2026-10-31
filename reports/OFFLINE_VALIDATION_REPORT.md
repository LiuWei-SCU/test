# 离线验证

最终专用容器通过 docker network disconnect bridge 移除网络；NetworkSettings.Networks 为 {}（见 disconnected-network.json）。
执行 scripts/verify.sh：先 help --offline，再 clean，删除四个顶层生成 JAR，autogenerate、核心库与三个桌面 JAR 分别重新构建，均成功。
最终日志中的七次 Gradle 成功耗时：17s、10s、18s、1m48s、38s、25s、16s。
随后运行 scripts/runtime-smoke.sh，通过 GUI、PDF、二维码往返及 FFmpeg/OpenCV/OpenBLAS 检查。
所有 Gradle 命令均使用 Wrapper、--offline --no-daemon --max-workers=2；未使用 BuildKit 临时 cache mount 保存依赖。
最终导出后的镜像仍需实际运行验证，其结果见外部 final-image 检查与 docker-load 日志。

最终镜像实际运行四个离线目标：通过，73 个任务。重新加载归档后离线 help：通过（12s，10 个任务）。镜像环境与运行冒烟检查均通过。
