- 【mx：在cydia安装的flex版本是旧的2.4.0，为了更新到最新的4.0.0，
我把项目拉下来，自己用了最新的flex，这样最后，就直接安装到了越狱的手机上】

## 第一步

第一步：clone项目，【mx：因为这个项目依赖的FLEX项目，所以需要先下载FLEX，
下面用了一条命令，就是--recurse-submodules，表示在clone本项目FLEXLoader的时候，
下载完本项目，就会clone下载子项目；遇到的问题是，clone github的项目是在太慢，
何况是两个github项目，于是我就将FLEX和FLEXLoader都克隆到gitee上，
然后，先子按下FLEXLoader，然后配置git中的子项目的地址就是配置FLEX的地址，
本来是github的，现在换成gitee，这样配置下来，使用下面的命令下载，速度就刷刷了】

- 命令

```
// --recurse-submodules这条命令是说从别的仓库下载
git clone  <https://github.com/buginux/FLEXLoader.git> --recurse-submodules

git clone  <https://gitee.com/erliucxy/FLEX.git> --recurse-submodules

// 从子模块下载项目的灵感来自「这里提供参考，下面命令没用」
git clone <https://github.com/johnno1962/InjectionIII> --recurse-submodules
```

- 修改github中的git配置，该从gitee下载该项目的源码

```
由于github太慢，专用gitee来下载，借用github相关配置
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
	precomposeunicode = true
[remote "origin"]
	url = <https://gitee.com/erliucxy/FLEXLoader.git>
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
[submodule "FLEX"]
	url = <https://gitee.com/erliucxy/FLEX.git>
```

## 第二步

第二步：
将本项目 clone 到本地，修改 Makefile 中的设备 IP 和 PORT，
{mx:这里制定端口和ip，就是为了再执行下面命令的时候，把这个tweak安装到越狱手机上}
然后执行 make package install 即可。
使用make命令，
必须配置tweak的开发环境，就是安装theos的环境。安装的方法参考越狱模块里面的安装指南。

- 现在还有一个问题，我们如何将 plist 文件还有 dylib 拷贝到 iOS 设备对应目录中。
当然，我们可以使用 scp 命令进行拷贝，
但是如果每次安装这个 Tweak 还需要先手动拷贝一次也未免太过麻烦。
- 而 Theos 已经帮我们解决这个问题了，我们只需要在 Tweak 的目录下建立一个 layout 目录，
这个目录对应的就是 iOS 设备上的根目录，在该 layout 目录下所有内容，会在编译 deb 的时候放到设备对应的目录下。
- 指定某个tag拉取代码

```
git clone --branch [tags标签] [git地址]

```

- 参考：
    - [使用 FLEX 调试任意第三方应用 - Swiftyper](https://www.notion.so/a6459b84eb8e4848afc1377c04b9e1c9?p=241eeb9becae4f5caa983007ad1343b3&showMoveTo=true)
        - 百度网盘文章有备份
    - [模仿FLEXLoader项目](https://github.com/buginux/FLEXLoader)

[Flex介绍](https://www.notion.so/Flex-60fcf3a2d98d4fddaa107c884cfb37c4)