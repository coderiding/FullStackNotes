### 分工

- TableViewController展示一个列表
- Presenter来取代以前TableViewController的工作，来撮合View和Model
- TableViewCell是定义的一个样式，属于MVP里面的View，那么Presenter拥有View
- 数据通过网络请求回来，被Presenter拥有，在cellForRow里面对Cell上的控件赋值，在Presenter里面，取出Mode数据，赋值给Cell上的控件
- TableViewController拥有Presenter，TableViewController把自己传给Presenter，Presenter弱引用TableViewController，在Presenter里面，将制作的View添加到传入的TableViewController上，设置Presenter为View的代理，处理View的事件
- 注意：这里的View和Model是相互独立的

优点：可以创建多个Presenter来完成TableViewController的工作，比如TableViewController上有多个View，那么可以通过多个Presenter来实现，最后拼在一起。

![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/2lfKC9.png](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/2lfKC9.png)