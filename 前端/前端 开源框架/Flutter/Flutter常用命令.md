## Flutter常用命令

```

// 查看帮助
flutter -h

// 检查环境
flutter doctor

// 接受安卓的证书
flutter doctor --android-licenses

// 查看flutter位置
which flutter

// 验证 Flutter 识别您连接的 Android 设备。
flutter devices

// 启动你应用程序
flutter run

```

## vscode 运行Flutter项目命令

```

// 常用的
flutter run  // 到vscode的终端，输入下面命令，运行项目
r // 修改代码后，保存，到终端输入r，就可以热重载项目




flutter  --version // 查看Flutter版本
flutter version // 查看所有版本
flutter  -h或者flutter  --help //打印所有命令行用法信息 
flutter  analyze //分析项目的Dart代码。
flutter  build // Flutter构建命令。
flutter channel //列表或开关Flutter通道。
flutter  clean //删除构建/目录。
flutter config //配置Flutter设置。
flutter  create // 创建一个新的Flutter项目。
flutter  devices //列出所有连接的设备。 
flutter doctor //展示了有关安装工具的信息。
flutter drive //为当前项目运行Flutter驱动程序测试。
flutter format //格式一个或多个Dart文件。
flutter  fuchsia_reload //在Fuchsia上进行热重载。
flutter help // 显示帮助信息的Flutter。
flutter install //在附加设备上安装Flutter应用程序。
flutter logs //显示用于运行Flutter应用程序的日志输出。
flutter packages //命令用于管理Flutter包。
flutter  precache //填充了Flutter工具的二进制工件缓存。
flutter  run //在附加设备上运行你的Flutter应用程序。
flutter screenshot //从一个连接的设备截图。
flutter stop //停止在附加设备上的Flutter应用。
flutter test //对当前项目的Flutter单元测试。
flutter trace //开始并停止跟踪运行的Flutter应用程序。
flutter upgrade //升级你的Flutter副本。

相关模拟器操作
flutter run  //运行项目
flutter emulators //模拟器列表
flutter emulators --launch <emulator id> //启动模拟器,只有启动模拟器才可以运行模拟器
  例如未启动模拟器列表:
　　Nexus_5X_API_28 • Nexus 5X • Google • Nexus 5X API 28
　　apple_ios_simulator • iOS Simulator • Apple

flutter emulators --launch Nexus_5X_API_28 //启动安卓模拟器
flutter run -d all //运行所有模拟器
flutter run -d <deviceId> //运行指定模拟器
例如模拟器列表:
Android SDK built for x86 • emulator-5554 • android-x86 • Android 9 (API 28) (emulator)
xxx的 iPhone • 00008020-001838491169002E • ios • iOS 12.2

flutter run -d emulator-5554 //运行安卓模拟器
flutter run -d 00008020-001838491169002E //运行IOS真机
flutter run -d all //运行所有模拟器

运行模拟器过程中命令

r //热更新直接刷新
R //热更新重启刷新
q //退出运行模拟器

```
