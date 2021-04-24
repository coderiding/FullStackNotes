## Flutter常见问题

### 问题：Mac 无法打开“idevice_id”，因为无法验证开发者的解决方法

* 下面的操作一次不行，多试几次。

```
// 第一步：
先执行 sudo spctl --master-disable

//第二步：再执行以下命令，【flutter解压后的目录】 需要替换成 你自己的对应目录
sudo xattr -r -d com.apple.quarantine 【flutter解压后的目录】/flutter/bin/cache/artifacts/libimobiledevice/idevice_id
sudo xattr -r -d com.apple.quarantine 【flutter解压后的目录】/flutter/bin/cache/artifacts/libimobiledevice/idevicename
sudo xattr -r -d com.apple.quarantine 【flutter解压后的目录】/flutter/bin/cache/artifacts/libimobiledevice/idevicescreenshot
sudo xattr -r -d com.apple.quarantine 【flutter解压后的目录】/flutter/bin/cache/artifacts/libimobiledevice/idevicesyslog
sudo xattr -r -d com.apple.quarantine 【flutter解压后的目录】/flutter/bin/cache/artifacts/libimobiledevice/ideviceinfo

// 我自己的配置
sudo xattr -r -d com.apple.quarantine /Users/coderiding/flutter/bin/cache/artifacts/libimobiledevice/idevice_id

sudo xattr -r -d com.apple.quarantine /Users/coderiding/flutter/bin/cache/artifacts/libimobiledevice/idevicename

sudo xattr -r -d com.apple.quarantine /Users/coderiding/flutter/bin/cache/artifacts/libimobiledevice/idevicescreenshot

sudo xattr -r -d com.apple.quarantine /Users/coderiding/flutter/bin/cache/artifacts/libimobiledevice/idevicesyslog

sudo xattr -r -d com.apple.quarantine /Users/coderiding/flutter/bin/cache/artifacts/libimobiledevice/ideviceinfo

```

### **问题：Waiting for another flutter command to release the startup lock**

- 查了一下github的flutter issue 找到了解决方法，如下： 
- 1、打开flutter的安装目录/bin/cache/ 
- 2、删除lockfile文件 
- 3、重启AndroidStudio

### **问题：flutter doctor的作用**

- 1.安装必要的集成环境，如 Downloading Dart SDK from Flutter engine ae8e6d9f46990b9585dc1fb5b8aabe491c08aaf3 
- 2.就是检查运行flutter要用到的环境，哪个没安装，就提示你安装 
- 3.该命令检查你的环境并在命令行窗口中显示报告。Dart SDK已经在打包在Flutter SDK里了，没有必要单独安装Dart。 仔细检查命令行输出以获取可能需要安装的其他软件或进一步需要执行的任务。

### **问题：Checking Android licenses is taking an unexpectedly long time**

1、使用命令 

```
flutter doctor --android-licenses
```

### 问题：Could not connect to lockdownd, error code

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

### **问题：升级flutter sdk**

- flutter upgrade 该命令会同时更新Flutter SDK和你的flutter项目依赖包。如果你只想更新项目依赖包（不包括Flutter SDK），可以使用如下命令：

  flutter packages get获取项目所有的依赖包。 

- flutter packages upgrade 获取项目所有依赖包的最新版本。

### **问题：显示Error: No pubspec.yaml file found**
* 打开项目总文件夹运行，不要打开上一级目录运行

### **问题：Flutter编译报错:The method 'CachedNetworkImageProvider.load' has fewer positional**
* 将cached_network_image的版本号升级到2.0.0-rc

```

cached_network_image: ^2.0.0-rc

```

### 问题：flutter升级后 运行项目报错 Warning: Podfile is out of date

* 找到Podfile文件直接删除,路径项目名称/ios/Podfile,或者可以通过在项目根目录中运行以下命令来执行此操作
* rm ios/Podfile

### 问题：fatal: unable to access 'https://github.com/XXXX/XXXX.git/': Failed to connect to github.com port 443: Timed out

* 执行下面的两条命令

```

git config --global http.proxy
 
git config --global --unset http.proxy

```