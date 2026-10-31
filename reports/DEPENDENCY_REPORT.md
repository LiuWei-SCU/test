# 依赖交付

DEPENDENCY_MANIFEST.csv 为最终 Linux 缓存工件及 SHA-256；构建所需插件与 Maven 依赖已经通过实际断网重新编译验证。
Linux 使用 FFmpeg 8.1.2-1.5.14、OpenCV 4.14.0-1.5.14、OpenBLAS 0.3.34-1.5.14、JavaCPP 1.5.14 的 linux-x86_64 工件。
Windows classifier 工件独立导出，不作为 Linux 运行依赖；不能互换 .so 与 DLL。

额外 Maven 工件按 group/artifact/version 文件布局保存，maven-repository.zip 包含下载到的 POM/JAR/module；不包含 Maven 本身，未宣称该集合能离线构建任意 Windows 项目。
pure-java-dependencies.zip 是扫描未发现 .dll/.so/.dylib/.jnilib 的 JAR 集合，含构建工具依赖，不等于应用运行 classpath。
完整工件内容分类见 JAR_NATIVE_INVENTORY.csv；其中包含额外交付的 Windows 与其他平台工件。原始 Windows 依赖清单未上传，因此没有冒充保留或使用它。
