Stylus是一个CSS预处理器。

官网安装：https://www.npmjs.com/package/stylus-loader

https://www.jianshu.com/p/94bd258f7e99


https://blog.csdn.net/m0_37679060/article/details/115427317
TypeError: this.getOptions is not a function (安装stylus)

原因：stylus-loader安装的版本过高

下面的版本对应是ok的，修改一下不兼容的，然后npm install一下（202010410遇到的这个问题，模仿饿了么项目的时候遇到）

"stylus": "^0.54.8",
"stylus-loader": "^3.0.2",
