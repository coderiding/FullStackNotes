https://juejin.cn/post/6844903917973667848  https://app.yinxiang.com/shard/s35/nl/9757212/c03e962b-4002-4936-a2ab-8fbaf67bdf98  RxDart——Dart和Flutter中的响应式编程入门

### whereType

这个转换器是Stream.where然后是Stream.cast缩写。

不匹配T的事件被过滤掉，结果流的类型为T。

```dart

Stream.fromIterable([1, 'two', 3, 'four'])
  .whereType<int>()
  .listen(print); // prints 1, 3

Stream.fromIterable([1, 'two', 3, 'four'])
  .where((event) => event is int)
  .cast<int>()
  .listen(print); // prints 1, 3



https://juejin.cn/post/6861232554704371719  rxdart学习笔记  https://app.yinxiang.com/shard/s35/nl/9757212/9121e7b1-18c3-426e-84d4-4efa81ebdef8  