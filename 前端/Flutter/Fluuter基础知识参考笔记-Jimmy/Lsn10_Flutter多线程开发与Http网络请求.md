# Lsn10.Flutter多线程开发与Http网络请求



[TOC]

## Stream

### 监听Stream的方法

```
StreamSubscription<T> listen(
  void onData(T event),//收到数据时触发
  {Function onError, //收到Error时触发
  void onDone(), //结束时触发
  bool cancelOnError});//遇到第一个Error时是否取消订阅，默认为false
StreamSubscription--控制Stream数据流
StreamSubscription有cancel、resume、pause、onData等方法。
```

### Stream的种类

流有两种: 

1. "Single-subscription" streams 单订阅流 
2. "broadcast" streams 多订阅流

## Flutter多线程开发

Dart是基于单线程模型的,不需要加锁机制。 
Dart中的代码都是运行在isolate中的，各个isolate之间的内存是没法直接共享的。但是可以通过ReceivePort和SendPort来实现isolate之间的通信。每个isolate都有自己对应的ReceivePort和SendPort，ReceivePort用于接受其他isolate发送过来的消息，SendPort则用于向其他isolate发送消息。 
每一个isolate中有一个消息循环机制（event loop）和两个队列（event queue和microtask queue）。

### spawn

```
external static Future<Isolate> spawn<T>(
  void entryPoint(T message), //指定了新isolate的初始运行函数，注意：该函数必须是顶层函数或者静态函数
  T message,//入口函数的唯一参数，通常包含一个SendPort，以便生产者与被生产者互相交流
  {bool paused: false,//如果赋值为true，则在启动时就暂停，相当于初始化时调用了isolate.pause方法，恢复可以调用isolate.resume方法
  bool errorsAreFatal,//如果忽略该参数，平台会以默认行为或者继承自当前isolate的行为来处理错误。
  SendPort onExit,
  SendPort onError});
  //如果errorsAreFatal、 onExit 和/或 onError 参数被赋值，就相当于在isolate启动前，setErrorsFatal, addOnExitListener 和/或 addErrorListener 分别以相应参数调用。
  //你也可以对返回的isolate调用setErrorsFatal、addOnExitListener 和 addErrorListene等方法，但是除非isolate以pause状态启动，它在这些方法调用前可能已经执行完毕了。
```











