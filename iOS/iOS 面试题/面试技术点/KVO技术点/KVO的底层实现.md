![51zALQ](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/51zALQ.png)

使用KVO，系统默认是下面的实现逻辑：

* 被监听的实例对象A
* 动态生成的子类B
* 子类B的父类是C

1.系统利用runtime API

2.系统会动态生成被监听实例对象类的子类B，类名是NSKVONotifying_XXX(可以通过object_getClass( )打印)

3.系统会将实例对象A的isa指向生成的子类B（此时打印A的类名就会是NSKVONotifying_XXX）

4.当修改instance对象A的属性时，会重写子类B的setter方法，setter方法会调用Foundation的_NSSetXXXValueAndNotify函数,如下图：

* willChangeValueForKey
* [super set....]
* didChangeValueForKey，这个方法里面又会触发observeValueForKeyPath

![5666](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/j4ypP8.png)

使用lldb打印方法的实现，添加监听后和没有监听的是不同的。
![334](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/g1cJ2X.png)