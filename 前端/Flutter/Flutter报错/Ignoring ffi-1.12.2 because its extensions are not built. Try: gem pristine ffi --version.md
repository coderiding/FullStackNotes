https://www.jianshu.com/p/8199ce31d5e5


执行pod命令时出现如上提示 如pod --version pod install  gem source -l等命令时 出现如下提示
Ignoring ffi-1.12.2 because its extensions are not built. Try: gem pristine ffi --version 1.12.2
解决方案：执行命令：sudo gem install cocoapods-core

gem pristine ffi --version 1.12.2

汶：总结

就是针对上面的名字，直接处理加权限就可以了，前面加sudo

输入：
sudo gem pristine ffi --version 1.12.2