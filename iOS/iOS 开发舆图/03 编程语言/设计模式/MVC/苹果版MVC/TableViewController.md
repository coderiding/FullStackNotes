### MVC关系图
![C1IO7e](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/C1IO7e.png)

---



### 核心
通过控制器来将从网络请求的数据转成Mode加载到View上，View被添加到控制器上，所以控制器拥有View和Model，控制器作为中间人来加载Mode到View上。

### 分工

- TableViewController展示一个列表，属于MVC里面的Controller
- TableViewCell是定义的一个样式，属于MVC里面的View，那么TableViewController拥有View
- 数据通过网络请求回来，被TableViewController拥有，在cellForRow里面对Cell上的控件赋值，在TableViewController里面，取出Mode数据，赋值给Cell上的控件
- 注意：这里的View和Model是相互独立的

### 问题：如何解决View上的点击事件

解决：

在View上设置代理，让TableViewController作为View的代理，监听View的点击

### 总结：

全程，View没有拥有Mode，Mode也没有拥有View，全部都是TableViewController拥有的Mode，拥有的View，由TableViewController来调配Mode和View的资源。

优点：View和Model可以重用，可以独立使用

缺点：TableViewController臃肿

![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/lh5KTt.png](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/lh5KTt.png)