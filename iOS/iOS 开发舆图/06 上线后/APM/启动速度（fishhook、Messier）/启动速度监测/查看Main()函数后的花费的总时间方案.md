查看Main函数之后的耗时，目前有两种方案：

- 方案一：定时抓取主线程方法的调用堆栈，计算一段时间里的方法耗时。（Xcode中的Time Profiler就是使用的这种的方法）
- 方案二：对objc_msgSend方法进行hook，来得到所有方法的耗时。
- 注：hook是指在原有方法开始执行时，换成你指定的方法（用Runtime的Method Swizzle / Facebook开源的fishhook框架https://github.com/facebook/fishhook）。或在原有方法的执行前后，添加执行你指定的方法。从而达到改变指定方法的目的。
（PS：关于fishhook，推荐阅读一篇博客：fishhook原理https://www.jianshu.com/p/4d86de908721）