---
title: iOS 多线程GCD之dispatch_group
tags: 多线程
categories: 技术改变世界
abbrlink: 21764
date: 2016-10-20 11:12:12
---

# iOS 多线程GCD之dispatch_group

> 本文通过介绍dispatch_group基本功能，通过实例讲解dispatch_group的用法。

dispatch_group是GCD(Grand Central Dispatch)中的一组方法，他有一个组的概念，可以把相关的任务归并到一个组内来执行，通过监听组内所有任务的执行情况来做相应处理。

dispatch_group有以下几种方法

#### dispatch_group_create

用于创建任务组

```objective-c
dispatch_group_t dispatch_group_create(void);
```

#### dispatch_group_async

把异步任务提交到指定任务组和指定下拿出队列执行

```objective-c
void dispatch_group_async(dispatch_group_t group,
                          dispatch_queue_t queue,
                          dispatch_block_t block);
```

- group   ——对应的任务组，之后可以通过`dispatch_group_wait`或者`dispatch_group_notify`监听任务组内任务的执行情况
- queue  ——block任务执行的线程队列，任务组内不同任务的队列可以不同
- block   —— 执行任务的block

<!-- more -->

#### dispatch_group_enter

用于添加对应任务组中的未执行完毕的任务数，执行一次，未执行完毕的任务数加1，当未执行完毕任务数为0的时候，才会使`dispatch_group_wait`解除阻塞和`dispatch_group_notify`的block执行

```objective-c
void dispatch_group_enter(dispatch_group_t group);
```

#### dispatch_group_leave

用于减少任务组中的未执行完毕的任务数，执行一次，未执行完毕的任务数减1，`dispatch_group_enter`和`dispatch_group_leave`要匹配，不然系统会认为group任务没有执行完毕

```objective-c
void dispatch_group_leave(dispatch_group_t group);
```

#### dispatch_group_wait

等待组任务完成，**会阻塞当前线程**，当任务组执行完毕时，才会解除阻塞当前线程 (dispatch_group_wait会同步地等待group中所有的block执行完毕后才继续执行,类似于dispatch barrier)

```objective-c
long dispatch_group_wait(dispatch_group_t group, 
                         dispatch_time_t timeout);
```

- group     ——需要等待的任务组
- timeout ——等待的超时时间（即等多久），单位为dispatch_time_t。如果设置为`DISPATCH_TIME_FOREVER`,则会一直等待（阻塞当前线程），直到任务组执行完毕

#### dispatch_group_notify

待任务组执行完毕时调用，不会阻塞当前线程 (功能与dispatch_group_wait类似，不过该过程是异步的，不会阻塞该线程，)

```objective-c
void dispatch_group_notify(dispatch_group_t group,
                           dispatch_queue_t queue, 
                           dispatch_block_t block);
```

- group   ——需要监听的任务组
- queue  ——block任务执行的线程队列，和之前group执行的线程队列无关
- block    ——任务组执行完毕时需要执行的任务block

#### 实例代码

以下代码简单演示group的使用方法，并测试group中嵌套异步代码存在的问题

```objective-c
dispatch_group_t group = dispatch_group_create();
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
NSLog(@"group one start");
dispatch_group_async(group, queue, ^{
    dispatch_async(queue, ^{
        sleep(1); //这里线程睡眠1秒钟，模拟异步请求
        NSLog(@"group one finish");
    });
});

dispatch_group_notify(group, queue, ^{
    NSLog(@"group finished");
});
```

控制台输出

```objective-c
2016-09-25 09:28:28.716 group one start
2016-09-25 09:28:28.717 group finished
2016-09-25 09:28:29.717 group one finish
```

**从打印结果可以看出，在group中嵌套了一个异步任务时，group并没有等待group内的异步任务执行完毕才进入`dispatch_group_notify`中，这是因为，在`dispatch_group_async`中又启了一个异步线程，而异步线程是直接返回的，所以group就认为是执行完毕了。**

对于以上这种情形，解决方案是使用`dispatch_group_enter`和`dispatch_group_leave`方法来告知group组内任务何时才是真正的结束。代码如下

```objective-c
dispatch_group_t group = dispatch_group_create();
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
NSLog(@"group one start");
dispatch_group_enter(group);
dispatch_async(queue, ^{
    sleep(1); //这里线程睡眠1秒钟，模拟异步请求
    NSLog(@"group one finish");
    dispatch_group_leave(group);
});

dispatch_group_notify(group, queue, ^{
    NSLog(@"group finished");
});



例子2
- (void)groupSync
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        sleep(5);
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(8);
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"任务完成");
    });
}
```

控制台输出

```objective-c
2016-09-25 09:34:07.672 group one start
2016-09-25 09:34:08.677 group one finish
2016-09-25 09:34:08.678 group finished
```

以上代码，通过`dispatch_group_enter`告知group，一个任务开始，未执行完毕任务数加1，在异步线程任务执行完毕时，通过`dispatch_group_leave`告知group，一个任务结束，未执行完毕任务数减1，当未执行完毕任务数为0的时候，这时group才认为组内任务都执行完毕了（这个和GCD的信号量的机制有些相似），这时候才会回调`dispatch_group_notify`中的block。

```objectivec
dispatch_group_async(group, queue, ^{ 
});
```

等价于

```objectivec
dispatch_group_enter(group);
dispatch_async(queue, ^{
　　dispatch_group_leave(group);
});
```

#### 示例Demo

我做了一个简单的[Demo](https://gitee.com/coderiding/DispatchGroupDemo.git)，将网络请求的2张图片拼装成一张图片展示。该demo就是使用dispatch_group方法，再两张图片都请求完成后，再将其拼装成一张图展示。有兴趣的童鞋可以看看~