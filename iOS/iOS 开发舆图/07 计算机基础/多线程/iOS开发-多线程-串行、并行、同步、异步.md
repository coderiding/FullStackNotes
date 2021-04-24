---
title: iOS开发-多线程-串行、并行、同步、异步
tags: 多线程
categories: 技术改变世界
abbrlink: 48813
date: 2018-06-20 12:25:08
---

### 一、一些基础概念

1. 进程概念：正在进行中的程序被称为进程，负责程序运行的内存分配，每一个进程都有自己独立的虚拟内存空间。
2. 线程概念：是进程中的一个独立执行路径控制单元，一个进程中至少包含一条线程叫做主线程。
3. 全局队列概念：是系统开发的，直接拿过来用，与并行队列类似，但调试时无法确认操作所在队列
4. 主队列概念：每一个应用程序对应唯一一个主队列，直接get使用，在多线程开发中，使用主队列更新UI

- 队列：队列负责管理多个任务，队列拥有一个线程池，池子里有一个或多个线程，它按要求将每个任务调度到某一个线程执行，说白了队列就是添加任务，队列就是往线程中添加任务，注意添加的时机。（串行、并行）一种先进先出的数据结构，线程的创建和回收不需言程序员操作，由队列负责。
- 线程：同步不会创建新的线程，会阻塞当前的线程在这个线程里执行任务，异步不会阻塞当前线程，会选择在恰当的时机在当前线程或者另开线程执行任务，看系统如何调度，开始任务和完成任务时间是不确定的。（同步、异步）

> 串行：后一个任务等待前一个任务结束后再执行，按添加顺序一个个执行（A执行完才添加B任务）
>  并行：后一个任务不会等待前一个任务，不等前一个任务完成就会分配新任务（B不用等待A执行完再添加任务）队列是先进先出的，任务执行完毕，不一定出队列，只有前面的任务执行完了，才会出队列。
>  同步：dispatch_sync，同步不会创建新的线程，会阻塞当前的线程在这个线程里执行任务
>  异步：dispatch_async，异步不会阻塞当前线程，会选择在恰当的时机在当前线程或者另开线程执行任务，看系统如何调度，开始任务和完成任务时间是不确定的。

# 

<!-- more -->

```swift
a.串行队列+同步任务：不会开启新的线程，任务逐步完成。
b.并行队列+同步任务：不会开启新的线程，任务逐步完成。
c.串行队列+异步任务：开启新的线程，任务逐步完成。
d.并行队列+异步任务：开启新的线程，任务是同步执行的。
```

![Xnip2020-10-28_14-40-47](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-28_14-40-47.jpg)

队列的执行效果

### 二、串行、并行、同步、异步的实战

1. 抛开同步异步，创建一个队列

```cpp
dispatch_queue_t serialQueue = dispatch_queue_create("my.serialQueue", DISPATCH_QUEUE_SERIAL);
dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
/*
dispatch_queue_t：队列
DISPATCH_QUEUE_SERIAL：串行
DISPATCH_QUEUE_CONCURRENT：并行
*/
```

1. 串行、并行、同步、异步的使用事例-------1

```objectivec
viewDidLoad进入时是mainQueue来调度任务，而mainQueue是串行的（Serial）
a. 串行同步（结果：1234）
dispatch_queue_t serialQueue = dispatch_queue_create("my.serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"1");
        NSLog(@"1sync %@", [NSThread currentThread]);
    });
    NSLog(@"2");
    dispatch_sync(serialQueue, ^{
        NSLog(@"3");
        NSLog(@"3sync %@", [NSThread currentThread]);
    });
    NSLog(@"4");
b. 并行同步（结果：1234）
dispatch_queue_t conCurrentQueue = dispatch_queue_create("my.conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(conCurrentQueue, ^{
        NSLog(@"1");
        NSLog(@"1sync %@", [NSThread currentThread]);
    });
    NSLog(@"2");
    dispatch_sync(conCurrentQueue, ^{
        NSLog(@"3");
        NSLog(@"3sync %@", [NSThread currentThread]);
    });
    NSLog(@"4");
c. 串行异步（结果：2413、2143、1234，只有一个子线程哦，因为是串行）
dispatch_queue_t serialQueue = dispatch_queue_create("my.serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"1");
        NSLog(@"1sync %@", [NSThread currentThread]);
    });
    NSLog(@"2");
    dispatch_async(serialQueue, ^{
        NSLog(@"3");
        NSLog(@"3sync %@", [NSThread currentThread]);
    });
    NSLog(@"4");
结果分析：因为是异步，所以24在主线程中，13在子线程中，又因为是串行，所以13和24顺序定了，但又因为是异步，完成时间不确定，所以会出现多种情况，2和4处于主线程串行队列哦～切记
d.并行异步（结果：24顺序一定，13顺序不一定，而且24处于处于主线程，13处于不同的子线程）
dispatch_queue_t conCurrentQueue = dispatch_queue_create("my.conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"1");
        NSLog(@"1sync %@", [NSThread currentThread]);
    });
    NSLog(@"2");
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"3");
        NSLog(@"3sync %@", [NSThread currentThread]);
    });
    NSLog(@"4");
```

1. 串行、并行、同步、异步的使用事例-------2



```objectivec
a.串行同步（结果：开始123～9结束）
-(void)test1
{
    dispatch_queue_t q = dispatch_queue_create("fs", DISPATCH_QUEUE_SERIAL);
    NSLog(@"开始：%@",[NSThread currentThread]);
    for (int i=0; i<10; i++) {
        if (i % 2 == 0) {
            [NSThread sleepForTimeInterval:1];
        } else {
            [NSThread sleepForTimeInterval:2];
        }
        dispatch_sync(q, ^{
            NSLog(@"sync--%@---%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"结束：%@",[NSThread currentThread]);
}
b.并行同步（结果：开始123～9结束）
-(void)test2
{
    dispatch_queue_t q = dispatch_queue_create("fs", DISPATCH_QUEUE_SERIAL);
    NSLog(@"开始：%@",[NSThread currentThread]);
    for (int i=0; i<10; i++) {
        dispatch_sync(q, ^{
            if (i % 2 == 0) {
                [NSThread sleepForTimeInterval:1];
            } else {
                [NSThread sleepForTimeInterval:2];
            }
            NSLog(@"sync--%@---%d",[NSThread currentThread],i);
        });
    }    NSLog(@"结束：%@",[NSThread currentThread]);
}
c.串行异步（结果：开始<结束不确定位置>123～9）
- (void)test3
{
    dispatch_queue_t serialQueue = dispatch_queue_create("my.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"开始：%@", [NSThread currentThread]);
    for (int i = 0; i < 10; i++) {
        dispatch_async(serialQueue, ^{
            if (i % 2 == 0) {
                [NSThread sleepForTimeInterval:1];
            } else {
                [NSThread sleepForTimeInterval:2];
            }
            NSLog(@"异步：%@------i：%d", [NSThread currentThread], i);
        });
    }
    NSLog(@"结束：%@", [NSThread currentThread]);
}
d.并行异步（结果：开始<1～9不确定，结束不确定>）
-(void)test4
{
    dispatch_queue_t q = dispatch_queue_create("fs", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"开始：%@",[NSThread currentThread]);
    for (int i=0; i<10; i++) {
        dispatch_async(q, ^{
            if (i % 2 == 0) {
                [NSThread sleepForTimeInterval:1];
            } else {
                [NSThread sleepForTimeInterval:2];
            }
            NSLog(@"sync--%@---%d",[NSThread currentThread],i);
        });
    }
    [NSThread sleepForTimeInterval:5];
    NSLog(@"结束：%@",[NSThread currentThread]);
}
```

1. 主线程死锁情况



```objectivec
NSLog(@"1");
dispatch_sync(dispatch_get_main_queue(), ^ {
  NSLog(@"2");
});
NSLog(@"3");
```

### 三、串行、并行、同步、异步的总结

1.不要向同一个串行队列添加同步任务，进行中的任务等待添加任务完成，添加的任务等待上一个任务完成，因为相互等待死循环，在currentQueue中谨慎使用dispatch_sync

1. 你需要知道的一些结论

```undefined
1.同步、异步决定是否创建子线程，同步任务不创建子线程，都是在主线程中执行，异步任务创建子线程

2.串行、并行决定创建子线程的个数，串行创建一个子线程，并行创建多个子线程

3.同步会阻塞线程，异步是开启另一个线程来执行，开启的这个是子线程。异步的子线程会在后台跑起来，甚至超过了主线程的速度，但是关于刷新UI的事情一定要回归主线程来执行。子线程不具备刷新UI的功能。可以更新的结果只是一个幻像：因为子线程代码执行完毕了，又自动进入到了主线程，执行了子线程中的UI更新的函数栈。

4.主线程中不能使用同步。会发生循环等待（主线程等待该线程执行完毕，该线程需要调用主线程执行）。

5.串行队列同步：操作不会新建线程、操作顺序执行；

6.串行队列异步：操作需要一个子线程，会新建线程、线程的创建和回收不需要程序员参与，操作顺序执行，是最安全的选择；

7.并行队列同步：操作不会新建线程、操作顺序执行；

8.并行队列异步：操作会新建多个线程（有多少任务，就开n个线程执行）、操作无序执行；队列前如果有其他任务，会等待前面的任务完成之后再执行；场景：既不影响主线程，又不需要顺序执行的操作！

9.全局队列异步：操作会新建多个线程、操作无序执行，队列前如果有其他任务，会等待前面的任务完成之后再执行；

10.全局队列同步：操作不会新建线程、操作顺序执行；

11.主队列异步：操作都应该在主线程上顺序执行的，不存在异步的；

12.主队列同步：如果把主线程中的操作看成一个大的block，那么除非主线程被用户杀掉，否则永远不会结束；主队列中添加的同步操作永远不会被执行，会死锁；
```

1. 深入

```cpp
1.全局队列，都在主线程上执行，不会死锁 dispatch_queue_priority_default
dispatch_queue_t q = dispatch_get_global_queue(dispatch_queue_priority_default, 0);

2.并行队列，都在主线程上执行，不会死锁 dispatch_queue_concurrent
dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcddemo", dispatch_queue_concurrent);

3.串行队列，会死锁，但是会执行嵌套同步操作之前的代码dispatch_queue_serial
dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcddemo", dispatch_queue_serial);

4.主队列，直接死锁 dispatch_get_main_queue();
dispatch_queue_t q = dispatch_get_main_queue();
```

1. dispatch_sync同步应用场景
    阻塞并行队列的执行，要求某一操作执行后在进行后续操作，如登陆，确保代码块之外的局部变量确实被修改

```objectivec
dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcddemo", dispatch_queue_concurrent);
  __block BOOL login = no;
  dispatch_sync(q, ^{
    NSLog(@"模拟耗时操作 %@", [NSThread currentthread]);
    [NSThread sleepfortimeinterval:2.0f];
    NSLog(@"模拟耗时完成 %@", [NSThread currentthread]);
    login = yes; 
 });
dispatch_async(q, ^{
  Nslog(@"登录完成的处理 %@", [nsthread currentthread]);
});
```

1. 主线程队列和GCD创建的队列区别
    主线程队列和GCD创建的队列是不同的，GCD创建的队列优先级没有主队列高，所以在GCD中的串行队列开启同步任务中没有嵌套任务是不会阻塞主线程，只有一种可能导致死锁，就是串行队列嵌套开启任务有可能导致死锁。
    主线程队列中不能开启同步，会阻塞主线程。只能开启异步任务，开启异步任务也不会开启新的线程，只是降低异步任务的优先级，让cpu空闲的时候才去调用。而同步任务，会抢占主线程的资源，会造成死锁。
2. 两个问题

> 1.在主队列开启异步任务，不会开启新的线程而是依然在主线程中执行代码块中的代码。为什么不会阻塞线程？
>  答：主队列开启异步任务，虽然不会开启新的线程，但是他会把异步任务降低优先级，等闲着的时候，就会在主线程上执行异步任务。
>  2.在主队列开启同步任务，为什么会阻塞线程？
>  答：在主队列开启同步任务，因为主队列是串行队列，里面的线程是有顺序的，先执行完一个线程才执行下一个线程，而主队列始终就只有一个主线程，主线程是不会执行完毕的，因为他是无限循环的，除非关闭应用程序。因此在主线程开启一个同步任务，同步任务会想抢占执行的资源，而主线程任务一直在执行某些操作，不肯放手。两个的优先级都很高，最终导致死锁，阻塞线程了。

### 四、NSThread、NSOperation、GCD

###### 1. NSThread

a.使用NSThread对象建立一个线程非常方便
 b.使用NSThread管理多个线程非常麻烦
 c.使用[NSThread currentthread]跟踪任务所在线程

###### 2. NSOperation

a.是使用GCD实现的一套Objective-c的API
 b.是面向对象的线程技术
 c.提供了一些在GCD中不容易实现的特性（限制最大并发数，操作之间的依赖关系）

###### 3. GCD

a.基于C语言的底层API
 b.用Block定义任务，使用起来非常灵活便捷
 c.提供了更多的控制能力以及操作队列中所不能使用的底层函数
