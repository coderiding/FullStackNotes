Widget就是View

### StatelessWidget的生命周期

只有一个生命周期：build

### StatefulWidget生命周期

![mRD8X5](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/mRD8X5.png)

![OTN9oj](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/OTN9oj.png)

* 初始化：插入渲染树
* 运行中：在渲染树中存在
* 销毁：从渲染树中移除

# 初始化
---
### createState
仅执行一次，它用来创建state

### initState
在创建StatefulWidget后，initState是第一个被调用的方法，同createState一样只被调用一次，此时widget的被添加至渲染树，mount的值会变为true，但并没有渲染。可以在该方法内做一些初始化操作。

### didChangeDependencies
当widget第一次被创建时，didChangeDependencies紧跟着initState函数之后调用，在widget刷新时，该方法不会被调用。它会在“依赖”发生变化时被Flutter Framework调用，这个依赖是指widget是否使用父widget中InheritedWidget的数据。也即是只有在widget依赖的InheritedWidget发生变化之后，didChangeDependencies才会调用。
这种机制可以使子组件在所依赖的InheritedWidget变化时来更新自身！比如当主题、locale(语言)等发生变化时，依赖其的子widget的didChangeDependencies方法将会被调用。

### build
build函数会在widget第一次创建时紧跟着didChangeDependencies方法之后和UI重新渲染是时调用。build只做widget的创建操作，如果在build里做其他操作，会影响UI的渲染效果。

# 运行中
---
### didUpdateWidget
当组件的状态改变的时候就会调用didUpdateWidget,比如调用了setState.

# 销毁
---
### deactivate
当要将State对象从渲染树中移除的时候，就会调用 deactivate 生命周期，这标志着 StatefulWidget将要销毁。页面切换时，也会调用它，因为此时State在视图树中的位置发生了变化但是State不会被销毁，而是重新插入到渲染树中。
重写的时候必须要调用 super.deactivate()

### dispose
从渲染树中移除view的时候调用，State会永久的从渲染树中移除，和initState正好相反mount值变味false。这时候就可以在dispose里做一些取消监听操作。

参考

https://juejin.cn/post/6844903910100959245   https://app.yinxiang.com/shard/s35/nl/9757212/29db17a6-072e-44cb-b171-3dcc6851ee33