---
title: 你不知道的的 iOS 多线程
tags: 多线程
categories: 技术改变世界
abbrlink: 11995
date: 2017-07-20 12:25:08
---
> 程序员用有限的生命去追求无限的知识。

## 有言在先

首先我不是故意要做标题党的，也不是我要炒冷饭，我只是想换个姿势看多线程，本文大部分内容在分析如何造死锁，奈何功力尚浅，然而再浅，也需要走出第一步。打开你的 Xcode 来验证这些死锁吧。

## 多线程小知识

以下是实现多线程的三种方式：

- NSThread
- GCD
- NSOperationQueue

关于[具体使用的方法](https://www.jianshu.com/p/0b0d9b1f1f19)不再具体介绍，让我们来看看他们不为人知的一面

#### 1. 锁的背后

`NSLock`是基于 POSIX threads 实现的，而 POSIX threads 中使用互斥量同步线程。

互斥量（或称为互斥锁）是 pthread 库为解决这个问题提供的一个基本的机制。互斥量是一个锁，它保证如下三件事情：

- **原子性** - 锁住一个互斥量是一个原子操作，表明操作系统保证如果在你已经锁了一个互斥量，那么在同一时刻就不会有其他线程能够锁住这个互斥量；
- **奇异性** - 如果一个线程锁住了一个互斥量，那么可以保证的是在该线程释放这个锁之前没有其他线程可以锁住这个互斥量；
- **非忙等待** - 如果一个线程（线程1）尝试去锁住一个由线程2锁住的锁，线程1会挂起（suspend）并且不会消耗任何CPU资源，直到线程2释放了这个锁。这时，线程1会唤醒并继续执行，锁住这个互斥量。

#### 2. 关于生命周期

通过 `[NSThread exit]` 方法使线程退出 ，`NSThread` 是可以立即终止正在执行的任务（可能会造成内存泄露，这里不深究）。甚至你可以在主线程中执行该操作，会使主线程也退出，app 无法再响应事件。而 `cancel` 可以通过作为标志位来达到类似目的，如果不做任何处理，仍然会继续执行。

GCD和NSOperationQueue可以取消队列中未开始执行的任务，对于已经开始执行的任务就无能为力了。

| 实现方式\功能    | 线程生命周期 | 取消任务               |
| ---------------- | ------------ | ---------------------- |
| NSThread         | 手动管理     | 立即停止执行           |
| GCD              | 自动管理     | 取消队列中未执行的任务 |
| NSOperationQueue | 自动管理     | 取消队列中未执行的任务 |

#### 3. 并行与并发

看到很多文章里提到 **并发队列** ，这里有一个小陷阱，混淆了 **并发** 和 **并行** 的概念。我们先来看看一下他们之间的区别：
![Xnip2020-11-09_20-59-08](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-09_20-59-08.jpg)

从图中可以看到，并行才是真正的多线程，而并发只是在多任务中切换。一般多核CPU可以并行执行多个线程，而单核CPU实际上只有一个线程，多路复用达到接近同时执行的效果。在 iOS 中 dispatch_async 和 globalQueue 从 Xcode 中线程使用情况来看，都达到了并行的效果。

#### 4. 队列与线程

队列是保存以及管理任务的，将任务加到队列中，任务会按照加入到队列中先后顺序依次执行。如果是全局队列和并发队列，则系统会根据系统资源去创建新的线程去处理队列中的任务，线程的创建、维护和销毁由操作系统管理，还有队列本身是线程安全的。

使用 NSOperationQueue 实现多线程的时候是可以控制线程总数及线程依赖关系的，而 GCD 只能选择并发或者串行队列。

## 资源竞争

多线程同时执行任务能提高程序的执行效率和响应时间，但是多线程不可避免地遇到同时操作同一资源的情况。前段时间看到的一个资源竞争的问题为例：

```
@property (nonatomic, strong) NSString *target; 
dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
for (int i = 0; i < 1000000 ; i++) { 
dispatch_async(queue, ^{ 
self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i]; 
}); 
}
```

解决办法：

- `@property (nonatomic, strong) NSString *target;`将`nonatomic`改成`atomic`。
- 将并发队列 `DISPATCH_QUEUE_CONCURRENT` 改成串行队列 `DISPATCH_QUEUE_SERIAL`。
- 异步执行`dispatch_async` 改成同步执行`dispatch_sync`。
- 赋值使用`@synchronized` 或者上锁。

这些方法都是从避免同时访问的角度来解决该问题，有更好的方法欢迎分享。

## 花样死锁

任何事情都有两面性，就像多线程能提升效率的同时，也会造成资源竞争的问题。而锁在保证多线程的数据安全的同时，粗心大意之下也容易发生问题，那就是 **死锁** 。

#### 1. NSOperationQueue

鉴于 NSOperationQueue 高度封装，使用起来非常简单，一般不会出什么幺蛾子，下面的案例展示了一个不好示范，通常我们通过控制 NSOperation 之间的从属关系，来达到有序执行任务的效果，但是如果互相从属或者循环从属都会造成所有任务无法开始。

```
NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
NSLog(@"lock 1 start");
[NSThread sleepForTimeInterval:1];
NSLog(@"lock 1 over");
}];

NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
NSLog(@"lock 2 start");
[NSThread sleepForTimeInterval:1];
NSLog(@"lock 2 over");
}];

NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
NSLog(@"lock 3 start");
[NSThread sleepForTimeInterval:1];
NSLog(@"lock 3 over");
}];

// 循环从属
[blockOperation2 addDependency:blockOperation1];
[blockOperation3 addDependency:blockOperation2];
[blockOperation1 addDependency:blockOperation3]; // 循环的罪魁祸首

// 互相从属
//[blockOperation1 addDependency:blockOperation2];
//[blockOperation2 addDependency:blockOperation1];

[_operationQueue addOperation:blockOperation1];
[_operationQueue addOperation:blockOperation2];
[_operationQueue addOperation:blockOperation3];
```

有没有人试过下面这种情况，如果好奇就试试吧！

```
[blockOperation1 addDependency:blockOperation1];
```

#### 2. GCD

大多数开发者都知道在主线程里同步执行任务会造成死锁，一起来看看还有哪些情况下会造成死锁或类似问题。

a. 在主线程同步执行 造成 `EXC_BAD_INSTRUCEION` 错误:

```
- (void)deadlock1 {
dispatch_sync(dispatch_get_main_queue(), ^{
NSLog(@"task 1 start");
[NSThread sleepForTimeInterval:1.0];
NSLog(@"task 1 over");
});
}
```

b. 和主线程同步执行类似，在串行队列中嵌套使用同步执行任务，同步队列 task1 执行完成后才能执行 task2 ，而 task1 中嵌套了task2 导致 task1 注定无法完成。

```
- (void)deadlock2 {
dispatch_queue_t queue = dispatch_queue_create("com.xietao3.sync", DISPATCH_QUEUE_SERIAL);

dispatch_sync(queue, ^{ // 此处异步同样会造成互相等待
NSLog(@"task 1 start");
dispatch_sync(queue, ^{
NSLog(@"task 2 start");
[NSThread sleepForTimeInterval:1.0];
NSLog(@"task 2 over");
});
NSLog(@"task 1 over");
});
}
```

嵌套同步执行任务确实很容易出 bug ，但不是绝对，将同步队列`DISPATCH_QUEUE_SERIAL` 换成并发队列 `DISPATCH_QUEUE_CONCURRENT` 这个问题就迎刃而解。修改成并发队列后案例中 task1 仍然要先执行完嵌套在其中的 task2 ，而 task2 开始执行时，并发队列不会发生互相等待导致阻塞问题 ， task2 执行完成后 task1 继续执行。

c. 在很多人印象中，异步执行不容易发生互相等待的情况，确实，即使是串行队列，异步任务会等待当前任务执行后再开始，除非你加了一些不健康的佐料。

```
- (void)deadlock3 {
dispatch_queue_t queue = dispatch_queue_create("com.xietao3.asyn", DISPATCH_QUEUE_SERIAL);
dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

dispatch_async(queue, ^{
__block NSString *str = @"xietao3";                             // 线程1 创建数据
dispatch_async(queue, ^{
str = [NSString stringWithFormat:@"%ld",[str hash]];        // 线程2 加工数据
dispatch_semaphore_signal(semaphore);
});
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
NSLog(@"%@",str);                                               // 线程1 使用加工后的数据
});
}
```

d. 常规死锁，在已经上锁的情况下再次上锁，形成彼此等待的局面。

```
if (!_lock) _lock = [NSLock new];
dispatch_queue_t queue = dispatch_queue_create("com.xietao3.sync", DISPATCH_QUEUE_CONCURRENT);

[_lock lock];
dispatch_sync(queue, ^{
[_lock lock];
[NSThread sleepForTimeInterval:1.0];
[_lock unlock];
});
[_lock unlock];
```

要解决也比较简单，将`NSLock`换成递归锁`NSRecursiveLock`，递归锁就像普通的门锁，顺时针转一圈加锁后，逆时针一圈即解锁；而如果顺时针两圈，同样逆时针两圈即可解锁。下面来一个递归的例子：

```
// 以下代码可以理解为顺时针转10圈上锁，逆时针转10圈解锁
- (void)recursivelock:(int)count {
if (count>10) return;
count++;
if (!_recursiveLock) _recursiveLock = [NSRecursiveLock new];

[_recursiveLock lock];
NSLog(@"task%d start",count);
[self recursivelock:count];
NSLog(@"task%d over",count);
[_recursiveLock unlock];
}
```

#### 3. 其他

除了上面提到的互斥锁和递归锁，其他的锁还有：

- OSSpinLock(自旋锁)
- pthread_mutex（OC中锁的底层实现）
- NSConditionLock（条件锁，对于新手更容易产生死锁）
- NSCondition（条件锁的底层实现）
- @synchronized（对象锁）

大部分锁触发死锁的情况和互斥锁基本一致，`NSConditionLock`使用起来会更加灵活，而自旋锁虽然性能爆表，但是存在漏洞，希望了解更多关于锁的知识可以[点这里](https://www.jianshu.com/p/8781ff49e05b)，在看的同时不要忘记亲自动手验证一下，边看边写边验证，记得更加深刻。

## 总结

关于多线程、锁的文章已经烂大街了，本文尽可能地从新的角度来看问题，尽量不写那些重复的内容，希望对你有所帮助，如果文中内容有误，欢迎指出。