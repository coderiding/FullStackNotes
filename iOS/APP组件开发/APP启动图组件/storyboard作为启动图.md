
# storyboard作为启动图

storyboard作为启动图

https://www.jianshu.com/p/1f186e1d52e2

Xcode新建工程，默认的启动图方式就是 LaunchScreen.storyboard。
若本身不是或之前有改动，则使用 LaunchScreen.storyboard 制作启动图步骤是：
（1）新建 storyboard
（2）添加一个视图控制器
（3）配置该视图控制器

在Xcode右侧，Attributes inspector中，勾选Is Initial View Controller
在Xcode右侧，File inspector中，勾选Use as Launch Screen
（4）TARGETS - General - App Icons and Launch Images中
Launch Images Source取消使用Launch Image，本身显示Use Asset Catalog...则无需理会
Launch Screen File选择刚创建的 storyboard
（5）部分情况下，可能启动图的确是 storyboard了，但图片就是未显示。此时尝试不把图片放在 xcassets 中，而是直接放在Xcode中，或新建一个文件夹来放。此问题查资料，貌似网友较多认为是Xcode的Bug

作者：不不不不同学
链接：https://www.jianshu.com/p/1f186e1d52e2
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。