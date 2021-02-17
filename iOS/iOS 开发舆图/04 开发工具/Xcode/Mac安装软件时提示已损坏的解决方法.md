Mac安装软件时提示已损坏的解决方法


https://www.waitsun.com/knowledge/installation-wrong

最新Catalina报错问题汇总
提示程序含有恶意代码或者已经打开所有来源还是提示扔到垃圾桶
在终端输入 xattr -r -d com.apple.quarantine 加上程序的App绝对路径，App建议直接拖放到终端，会自动填写路径

如这样：xattr -r -d com.apple.quarantine /Applications/QQ.app

常规报错解决方案一
2019年7月10号开始，很多TNT破解软件大面积报错，原因不多说，讲一下具体的解决方案

步骤一：
安装xcode，这个在商店里面有，不想安装的，按步骤二来。

步骤二：
安装Command Line Tool 工具

打开终端输入以下命令

xcode-select --install （install前面为两个短横线）

步骤三：
终端继续输入以下命令

codesign --force --deep --sign - （force、deep、sign前面为两个短横线）

然后拖入需要签名的软件，最后类似于这样

codesign --force --deep --sign - /Applications/name.app （/Applications前面有一个空格）

回车搞定

常规报错解决方案二
不想知道原理和偷懒的，安装软件，直接给报错程序签名。

 免费下载 高速下载  荔枝正版
常规报错解决方案三
从本站下载的Sketch、Principle等设计软件，以及输入法等常用软件，安装时总是提示“已损坏，移至废纸篓”这类信息，根本无法打开。如下图：

Mac安装软件时提示已损坏的解决方法-麦氪派
其实，这是新系统（macOS Sierra 10.12.X）惹的祸。新系统加强了安全机制，默认不允许用户自行下载安装应用程序，只能从Mac App Store里安装应用。

解决方法
步骤一：打开终端

Mac安装软件时提示已损坏的解决方法-麦氪派
步骤二：输入代码：sudo spctl --master-disable（master前面为两个短横线，看下面的截图）

Mac安装软件时提示已损坏的解决方法-麦氪派
注意红框处应有空格
步骤三：按回车输入自己电脑密码，再次回车（密码不会显示出来，放心输就好）

Mac安装软件时提示已损坏的解决方法-麦氪派
不显示密码，输完按回车

步骤四：打开系统偏好设置 » 安全性与隐私，若显示任何来源，大功告成；若没有此选项，一定是你前面的步骤不对

Mac安装软件时提示已损坏的解决方法-麦氪派
回到桌面双击安装文件，发现都可以打开啦，尽情享受Mac带给你的乐趣吧！

常规报错解决方案四
32位程序不兼容，报类似以下的错误

Mac安装软件时提示已损坏的解决方法-麦氪派
终端输入

defaults write -g CSUIDisable32BitWarning -boolean TRUE