# BoofCV 1.6.0 云端构建报告

## 版本与环境

- 官方源码：https://github.com/lessthanoptimal/BoofCV.git
- 标签 v1.6.0；Commit c6401d374de710a3a6904480717970573ad05b82，与预期完全一致。
- data 子模块：6203cd72da3c370d54d1b64435c812518cdccc34，已初始化。
- Ubuntu 22.04.5 / linux/amd64；Azul OpenJDK 25.0.5；Wrapper Gradle 9.2.0。
- 工程明确固定 Java 25 + Azul vendor，JDK 17 单独不足以编译，因此遵照实际 toolchain 使用 25，未修改版本声明。
- 原始已跟踪源码 git diff 为空。执行了官方 autogenerate，新增生成源码保留；原始源码归档 original-source.tar.gz 与文件基线 source-sha256.json 一并保存。

## 实际构建结果

| 目标 | 在线 | 容器断网、清理后离线重编译 |
|---|---|---|
| tasks --all | 通过 | 不作为离线编译目标 |
| help | 已完成配置 | 通过 |
| autogenerate | 通过 | 通过 |
| oneJarBin 核心库 | 通过 | 通过 |
| :applications:applicationsJar | 通过 | 通过 |
| :examples:examplesJar | 通过 | 通过 |
| :demonstrations:demonstrationsJar | 通过 | 通过 |

最终离线验证时 Docker 网络连接表为空，非 Linux Bytedeco native classifier 已移除，使用工程支持的 ORG_GRADLE_PROJECT_native_arch=linux-x86_64，未改源码。

## 实际运行验证

- Applications 命令行启动并列出 CameraCalibrationMono/Stereo/Multi 入口。
- CreateCalibrationTarget 成功生成非空 chessboard.pdf。
- Examples 与 Demonstrations 在 Xvfb 下显示 1200x600 的有内容窗口，分别观察到 13/16 个树节点行。
- 官方 ExampleQrCodeBinaryData 完成生成、检测、解码往返，输出 Matched: true。
- FFmpeg avcodec_version=4070502；OpenCV major=4；OpenBLAS cblas_dasum([-1,2,-3])=6.0。
- 这些检查均在无网络环境执行；没有物理显示器也完成了 GUI 启动检查。

## 网络与故障处理

Maven Central、Gradle 插件站及 services.gradle.org 返回 200。Google Maven 目录首页返回 404，但项目所需 Google 工件已通过真实 Gradle 解析。Docker Registry /v2/ 返回正常 401 认证挑战，镜像实际拉取成功。
保留 TLS 与软件包签名验证；代理 CA 通过临时只读挂载和临时 Java truststore 使用，未保留会话 truststore。
Azul 额外 apt 源曾返回代理 403；Ubuntu 已签名软件源安装成功，JDK 来自按 digest 固定的 Azul 镜像。

初次标签浅克隆缺少 Spotless 引用 origin/SNAPSHOT，补取官方引用后 tasks --all 通过。一个 native 验证脚本曾调用不存在的 OpenBLAS 方法，核对实际 API 后改为真实求和检查并通过。VFS 镜像层复制导致空间压力，清理本任务中间缓存后改用专用容器验收并压平镜像。失败和取消日志均保留。

## 镜像制作与复现

实际路径：Docker 构建 Ubuntu/JDK 基础层 → 专用容器在线编译 → 断开容器网络 → 清理并离线重编译及运行 → Docker export/import 压平文件系统 → docker save 导出真正的 Docker Archive。
Dockerfile 提供等效的完整源码构建路径；scripts/cloud-build.sh 记录实际流程。为避免重复耗时，本次没有将整理后的完整脚本或完整 Dockerfile 再从头执行一遍。首次 Dockerfile 构建的失败不作为最终镜像成功证据；最终归档、加载及运行结果单独记录在 dist 清单和外部日志。
所有源码、缓存、JAR、Linux runtime、构建日志及检查脚本均来自容器内部文件系统；最终镜像不需要宿主挂载卷。

## 明确未验证与限制

- 未在 Windows 10/11 Docker Desktop 实机执行；提供加载与运行说明，不宣称已完成 Windows 实机验收。
- 未验证真实相机、GPU、所有具体 GUI 演示、Windows 图形转发。
- Android APK/AAR、Android SDK、完整 JUnit/benchmark 套件未构建或执行；离线完整性结论限定在上表的开发工作流。
- Windows native 与 Maven 工件已单独整理，未在 Windows 原生 Java/VS 中实际编译运行。
- 未加入独立 Windows classifier 库作为 Linux 运行依赖。上游 JNA、BridJ、WebcamCapture、Byte Buddy、Kotlin/Gradle 等通用 JAR 仍可能带 Windows DLL 等资源，保持官方工件完整，不能称为“镜像内绝无 DLL”；Linux native 已实际加载验证。

## 最终归档验收（镜像封装后）

镜像 ID：sha256:64e76b903c83f3438ffa240a31bdf0af354e90c6b9c3ea22aea6397ab16910d1；linux/amd64；未压缩 3729993485 bytes。归档 2238670915 bytes；SHA-256：5e53e9f15ac84226c86dbfb179345e15db2dffb157493e9e2f47fe4a529eccab。
最终镜像中再次运行四个离线构建目标通过（73 个任务，18 个执行、55 个 up-to-date）。无网络无挂载的全部运行检查通过。Docker save 归档包含 manifest.json、gzip 校验通过，实际 docker load 成功，重新加载后 Gradle help --offline --no-daemon 通过。见 dist/IMAGE_MANIFEST.md 与对应最终日志。
