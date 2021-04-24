使用Flutter内置美丽的Material Design和Cupertino（iOS风格）widget、丰富的motion API、平滑而自然的滑动效果和平台感知，为您的用户带来全新体验。

纸墨设计（Material Design）风格

material.dart里面包含的就是所有对外开放类库的头文件

uses-material-design: true的作用仅仅是决定Material图标是否应用到项目中。

Material其实是包含cupertino的，cupertino只是对Material中某些控件的第二种封装，部分组件提供额外一套风格的选择。

### MaterialApp属性

* 1、title ： 在任务管理窗口中所显示的应用名字

* 2、theme ： 应用各种 UI 所使用的主题颜色

* 3、color ： 应用的主要颜色值（primary color），也就是安卓任务管理窗口中所显示的应用颜色

* 4、home ： 应用默认所显示的界面 Widget

* 5、routes ： 应用的顶级导航表格，这个是多页面应用用来控制页面跳转的，类似于网页的网址

如果应用只有一个界面，则不用设置这个属性

如果所查找的路由在 routes 中不存在，则会通过 onGenerateRoute 来查找。

 '/' 和 home 属性，二者不能同时存在，但是必须有一个存在：

* 6、initialRoute ：第一个显示的路由名字，默认值为 Navigator.defaultRouteName

当initialRoute 和 '/' 或者 home 属性同时存在的时候，initialRoute 的优先级高于二者

如果这个属性没有给值，那么会去寻找路由表里面的 '/' ，或者 home 属性（上面第四个属性）。

* 7、onGenerateRoute ： 生成路由的回调函数，当导航的命名路由的时候，会使用这个来生成界面

* 8、onLocaleChanged ： 当系统修改语言的时候，会触发这个回调

* 9、navigatorObservers ： 应用 Navigator 的监听器

* 10、debugShowMaterialGrid ： 是否显示 纸墨设计 基础布局网格，用来调试 UI 的工具

* 11、showPerformanceOverlay ： 显示性能标签
  
* 12、debugShowCheckedModeBanner ：是否显示右上角DEBUG标签 （调试开关）

* 13、checkerboardRasterCacheImages ：检查缓存的图像开关，检测在界面重绘时频繁闪烁的图像（调试开关）

* 14、 showSemanticsDebugger ：是否打开Widget边框，类似Android开发者模式中显示布局边界（调试开关）

---
参考

https://www.jianshu.com/p/2b412e5c9617  https://app.yinxiang.com/shard/s35/nl/9757212/00663a24-ea48-4aa2-8b91-bbdc4b2bbba0

https://www.jianshu.com/p/e4aa45ff08d6  https://app.yinxiang.com/shard/s35/nl/9757212/7bcb6c5c-4892-487d-b1fe-abfe2f4c4f64