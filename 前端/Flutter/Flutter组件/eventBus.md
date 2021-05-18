https://my.oschina.net/u/4260177/blog/4316488  Flutter学习笔记（34）--EventBus的使用    https://app.yinxiang.com/shard/s35/nl/9757212/e624fa16-f2ba-4567-a2dd-674e2b73192e


```DART
///触发：
EventBusUtils.getInstance().fire(DoubleContentEvent(2.2));

///销毁：关闭event事件流,不然会造成内存泄漏,调用如下代码即可:
EventBusUtils.getInstance().destroy();

///监听：
EventBusUtils.getInstance().on<DoubleContentEvent>().listen((event) {
print(event.max);
setState(() {
_max = event.max;
});
