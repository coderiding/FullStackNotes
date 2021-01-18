由于Flutter会同时构建Android和IOS两个平台的发布包，所以Flutter同时依赖Android SDK和iOS SDK，在安装Flutter时也需要安装相应平台的构建工具和SDK。下面我们分别介绍一下Windows和macOS下的环境搭建。

# **搭建Flutter环境**

## **Mac搭建Flutter开发环境**

说明：由于Flutter会同时构建Android和IOS两个平台的发布包，所以Flutter同时依赖Android SDK和iOS SDK，在安装Flutter时也需要安装相应平台的构建工具和SDK。下面我们分别介绍一下Windows和macOS下的环境搭建。

在终端按照下面的命令输入：

```
// 添加下面的两个源，就可以通过国内网络下载Flutter
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

// 开始下载
git clone -b dev <https://github.com/flutter/flutter.git>

// 将Flutter加到Path中，才可以使用Flutter命令，这里是临时设置，可以考虑永久设置。
export PATH="$PWD/flutter/bin:$PATH"
cd ./flutter

// 检查Flutter运行环境有没有什么缺的，如果检查出来有什么问题，就根据提示做就行，缺什么补什么
// 我的Mac因为安装了Android Studio，也装了Xcode开发的环境，所以安装很顺利
flutter doctor

```

## **一、安装Android Studio上的Flutter插件和Dart插件**

Flutter插件： 支持Flutter开发工作流 (运行、调试、热重载等)。

Dart插件： 提供代码分析 (输入代码时进行验证、代码补全等)。

步骤：

- 1.启动Android Studio。
- 2.打开插件首选项 (macOS：Preferences>Plugins, Windows：File>Settings>Plugins)。
- 3.选择 Browse repositories…，选择 flutter 插件并点击 install。
- 4.重启Android Studio后插件生效。
- 5.接着就可以直接创建Flutter应用了
- 6.接下来，让我们用Android Studio创建一个Flutter项目，然后运行它，并体验“热重载”。

## **二、VS Code安装flutter插件**

- 1.启动 VS Code。
- 2.调用 View>Command Palette…。
- 3.输入 ‘install’, 然后选择 Extensions: Install Extension action。
- 4.在搜索框输入 flutter ，在搜索结果列表中选择 ‘Flutter’, 然后点击 Install。
- 5.选择 ‘OK’ 重新启动 VS Code。
    - 1.验证配置
    - 2.调用 View>Command Palette…
    - 3.输入 ‘doctor’, 然后选择 ‘Flutter: Run Flutter Doctor’ action。
    - 4.查看“OUTPUT”窗口中的输出是否有问题

# **问题**

## **问题一：Waiting for another flutter command to release the startup lock**

- 查了一下github的flutter issue 找到了解决方法，如下：
- 1、打开flutter的安装目录/bin/cache/
- 2、删除lockfile文件
- 3、重启AndroidStudio

## **问题二：flutter doctor的作用**

- 1.安装必要的集成环境，如 Downloading Dart SDK from Flutter engine ae8e6d9f46990b9585dc1fb5b8aabe491c08aaf3
- 2.就是检查运行flutter要用到的环境，哪个没安装，就提示你安装
- 3.该命令检查你的环境并在命令行窗口中显示报告。Dart SDK已经在打包在Flutter SDK里了，没有必要单独安装Dart。 仔细检查命令行输出以获取可能需要安装的其他软件或进一步需要执行的任务。

## **问题三：Checking Android licenses is taking an unexpectedly long time**

1、使用命令

```
flutter doctor --android-licenses
```

问题四：Could not connect to lockdownd, error code

finally works after 跟着下面的命令敲

```
brew uninstall --ignore-dependencies libimobiledevice
brew uninstall --ignore-dependencies ideviceinstaller
brew uninstall --ignore-dependencies usbmuxd
sudo rm /var/db/lockdown/*
brew install --HEAD usbmuxd
brew unlink usbmuxd
brew link usbmuxd
brew install --HEAD libimobiledevice
brew install --HEAD ideviceinstaller
```

## **问题五：修改mac的环境变量**

### **5.1 临时修改Flutter环境变量**

```
export PATH="$PWD/flutter/bin:$PATH"
```

### **5.2 持久修改**

- a、打开(或创建) $HOME/.bash_profile。文件路径和文件名可能在你的电脑上不同.
- b、如果Flutter安装目录是“~/code/flutter_dir”，那么添加的代码是
- export PATH=~/code/flutter_dir/flutter/bin:$PATH
- 我自己的是：
- export PATH=~/Documents/MXCode/flutter/bin:$PATH
- c、运行 source $HOME/.bash_profile 刷新当前终端窗口。
- d、验证“flutter/bin”是否已在PATH中： echo $PATH

### **5.3 注意**

./bash_profile 该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该文件被读取.（每个用户都有一个.bashrc文件，在用户目录下） 使用注意 需要需要重启才会生效，/etc/profile对所有用户生效，~/.bash_profile只对当前用户生效。

## **问题六：升级flutter sdk**

- flutter upgrade 该命令会同时更新Flutter SDK和你的flutter项目依赖包。如果你只想更新项目依赖包（不包括Flutter SDK），可以使用如下命令：

    flutter packages get获取项目所有的依赖包。

- flutter packages upgrade 获取项目所有依赖包的最新版本。

[极速调试](https://www.notion.so/1c4c3e3a23cd4b21866cd2e3484c173d)