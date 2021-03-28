类似MVP,把P换成ViewModel。

不同点，View会监听ViewModel的数据变化，然后View可以刷新显示界面

### MVVM实现图

![haEnVZ](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/haEnVZ.png)


### MVVM核心

* ViewModel和View双向绑定
* ViewMode的属性几乎与Model的属性一致

### MVVM实现步骤
* 第一步：在ViewModel中创建View，添加View到ViewModel的拿过来的控制器上。并且把ViewModel传给View。
* View拥有ViewModel
* 第二步：所以在View中就直接监听ViewModel属性的改变，然后触发自己控件上的元素进行改变，刷新界面。

### 实例代码用到框架
Facebook的方便使用KVO的KVOControoler