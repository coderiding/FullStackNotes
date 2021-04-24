## Flutter开发环境配置

### mac安装Flutter
* 配置环境变量

```

vim ~/.bash_profile

export PATH=/你的flutter文件夹所在位置/flutter/bin:$PATH
export PATH=/Users/coderiding/flutter/bin:$PATH

// 更新环境变量
source ~/.bash_profile

```

### **安装Android Studio上的Flutter插件和Dart插件**

Flutter插件： 支持Flutter开发工作流 (运行、调试、热重载等)。 

Dart插件： 提供代码分析 (输入代码时进行验证、代码补全等)。

步骤： 

- 1.启动Android Studio。 
- 2.打开插件首选项 (macOS：Preferences>Plugins, Windows：File>Settings>Plugins)。 
- 3.选择 Browse repositories…，选择 flutter 插件并点击 install。 
- 4.重启Android Studio后插件生效。 
- 5.接着就可以直接创建Flutter应用了 
- 6.接下来，让我们用Android Studio创建一个Flutter项目，然后运行它，并体验“热重载”。

### **VS Code安装flutter插件**

- 1.启动 VS Code。 
- 2.调用 View>Command Palette…。 
- 3.输入 ‘install’, 然后选择 Extensions: Install Extension action。 
- 4.在搜索框输入 flutter ，在搜索结果列表中选择 ‘Flutter’, 然后点击 Install。 
- 5.选择 ‘OK’ 重新启动 VS Code。 
  - 1.验证配置 
  - 2.调用 View>Command Palette… 
  - 3.输入 ‘doctor’, 然后选择 ‘Flutter: Run Flutter Doctor’ action。 
  - 4.查看“OUTPUT”窗口中的输出是否有问题