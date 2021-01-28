### 分工

还是用TableView来举例

- TableViewController展示一个列表，属于MVC里面的Controller
- TableViewCell是定义的一个样式，属于MVC里面的View，那么TableViewController拥有View
- 数据通过网络请求回来，被TableViewController拥有，在cellForRow里面对Cell上的控件赋值，在TableViewController里面，取出Mode数据，赋值给Cell上的控件，赋的值是Model，就是View上拥有Model对象
- 注意：这里的View拥有Model对象，在TableViewController，将Model赋值给View上的Model对象，所以看下图，View是拥有Model的，同事TableViewController也是拥有Model的，然后为什么Controller和View是互相拥有呢，TableViewController拥有View这个是好理解，View为什么拥有Controller呢，因为View把TableViewController设置为自己的代理了。为什么设置代理，就是解决View上的点击事件的。

### 问题：如何解决View上的点击事件

解决：

在View上设置代理，让TableViewController作为View的代理，监听View的点击

优点：将在TableViewController赋值的操作移到了View里面，分担TableViewController的压力。

![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/HJmm0j.png](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/HJmm0j.png)