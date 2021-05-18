https://book.flutterchina.club/chapter8/eventbus.html

总结：就是及时用来通知别的Widget干活的。

你有一个主界面，里面有一些信息可能会修改，但触发源不在该界面，是在其他的界面触发了一些事件后，首页的内容需要做修改。如果没有EventBus，也有很多的方式可以实现，譬如定义全局静态变量、或者定义个CallBack接口传出去等等。不管怎样，总是要把主页和触发源关联起来，这是相当难受的，这不但会导致代码量暴涨，同时还会导致耦合度极高，不得不写的这个引用让人如鲠在喉。

https://blog.csdn.net/qq_43377749/article/details/115050851  https://app.yinxiang.com/shard/s35/nl/9757212/a79b5b67-8a8a-49c2-a0b4-4e53b895ed76