---
title: 关于GCD同步组实现多个异步线程的同步执行中的注意点
tags: 多线程
categories: 技术改变世界
abbrlink: 4309
date: 2017-01-20 09:15:18
---

> 在App开发中经常会遇到多个线程同时向服务器取数据, 如果每个线程取得数据后都去刷新UI会造成界面的闪烁；也有可能出现部分数据还没有获取完毕造成程序crash。之前在网上看到很多是利用`dispatch_group_async`、`dispatch_group_t`与`dispatch_group_notify` 组合来实现的



* 比如这样：将几个线程加入到group中, 然后利用group_notify来执行最后要做的动作

```
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    //创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个GCD线程1
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"线程1");
    });
    
    //创建一个GCD线程2
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"线程2");
    });
    
    //创建一个GCD线程3
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"线程3");
    });
    
    //创建一个group通知
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"结束");
    });
}
```

* 运行结果:

```
2017-01-18 11:49:22.454 GCDDemo[1375:107838] 线程2
2017-01-18 11:49:22.454 GCDDemo[1375:107837] 线程3
2017-01-18 11:49:22.454 GCDDemo[1375:107840] 线程1
2017-01-18 11:49:22.454 GCDDemo[1375:107840] 结束
```

<!-- more -->

* 看起来是3个线程无序运行, 最后等全部线程结束后才执行group结束动作. 看样子都很正常；但如果3个线程为异步操作呢, 比如网络请求，我们用异步计数试试看

```
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    //创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个GCD线程1
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程1");
        });
    });
    
    //创建一个GCD线程2
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程2");
        });
    });
    
    //创建一个GCD线程3
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程3");
        });
    });
    
    //创建一个group通知
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"结束");
    });
}
```

* 运行结果为:

```
2017-01-18 13:31:57.610 GCDDemo[1528:138162] 结束
2017-01-18 13:31:57.621 GCDDemo[1528:138079] 线程1
2017-01-18 13:31:57.621 GCDDemo[1528:138079] 线程2
2017-01-18 13:31:57.622 GCDDemo[1528:138079] 线程3
```

* 看, 这样就出问题了 先运行了我们原本要等线程都完成后才执行的动作，那要如何解决这个问题呢? 正确的方法应该是以上三个函数再配合dispatch_group_enter(group)`和`dispatch_group_leave(group)`两个函数一起来使用，这样才能实现我们想要的最终效果。



**dispatch_group_enter(dispatch_group_t group)**

* 参数group不能为空，在异步任务开始前调用。
* 它明确的表明了一个 block 被加入到了队列组group中，此时group中的任务的引用计数会加1`(类似于OC的内存管理)`
* dispatch_group_enter(group)`必须与`dispatch_group_leave(group)`配对使用，`
* 它们可以在使用`dispatch_group_async`时帮助你合理的管理队列组中任务的引用计数的增加与减少。

 

**dispatch_group_leave(dispatch_group_t group)**

* 参数group不能为空，在异步任务成功返回后调用。
* 它明确的表明了队列组里的一个 block 已经执行完成，队列组中的任务的引用计数会减1，
* 它必须与`dispatch_group_enter(group)`配对使用，`dispatch_group_leave(group)`的调用次数不能多于`dispatch_group_enter(group)`的调用次数。
* 当队列组里的任务的引用计数等于0时，会调用`dispatch_group_notify`函数。

 

* 我们试试看

```
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个group
    __block dispatch_group_t group = dispatch_group_create();
    
    //创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //group任务计数加3
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    //创建一个GCD线程1
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程1");
            //group任务计数减1
            dispatch_group_leave(group);
        });
    });
    
    //创建一个GCD线程2
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程2");
            //group任务计数减1
            dispatch_group_leave(group);
        });
    });
    
    //创建一个GCD线程3
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程3");
            //group任务计数减1
            dispatch_group_leave(group);
        });
    });
    
    //创建一个group通知, 任务计数为0时自动调用
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"结束");
    });
}
```

* 运行结果:

```
2017-01-18 13:46:59.988 GCDDemo[1564:144979] 线程1
2017-01-18 13:46:59.991 GCDDemo[1564:144979] 线程2
2017-01-18 13:46:59.991 GCDDemo[1564:144979] 线程3
2017-01-18 13:46:59.993 GCDDemo[1564:145035] 结束
```

这样就符合我们的预期了，还没结束, 不  上面的方法是可以正确的实现多线程同步了, 现在我们再看下另外一种解决办法



### 利用GCD信号量dispatch_semaphore_t来实现

我们先看下什么是信号量

##### 首先了解下信号量的几个方法

```
1.dispatch_semaphore_create(long value)；
   创建信号量，传入的value值要大于等于0，返回一个信号量
 2.dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout)；
   如果信号量的value值大于0，则会往下执行并将value的值减1，否则，阻碍当前线程并等待timeout后再往下执行。如果等待的期间desema的值被dispatch_semaphore_signal函数加1了，且该函数所处线程获得了信号量，那么就继续向下执行并将信号量减1。如果等待期间没有获取到信号量或者信号量的值一直为0，那么等到timeout时，其所处线程会自动往下执行。
 3.dispatch_semaphore_signal(dispatch_semaphore_t dsema)；
   返回值为long类型，当返回值为0时表示当前并没有线程等待其处理的信号量，其处理的信号量的值加1即可。当返回值不为0时，表示其当前有（一个或多个）线程等待其处理的信号量，并且该函数唤醒了一个等待的线程（当线程有优先级时，唤醒优先级最高的线程；否则随机唤醒）。
```



实现过程：

- 创建一个任务组dispatch_group

```
 dispatch_group_t group = dispatch_group_create();
```

- 将每个请求包装成一个任务异步提交到任务组里，每个任务在一开始创建一个信号量，value值为0，任务最后在网络请求完成前进行信号量的等待，如果网络请求完成，则调用 'dispatch_semaphore_signal(semaphore);'对信号值加1，则线程不再进行信号量的等待，继续往下执行。
- 当所有请求都完成时，会在dispatch_group_notify里的回调进行相应的处理。



我们上代码看看:

```
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个group
    __block dispatch_group_t group = dispatch_group_create();
    
    //创建一个队列
    __block dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //创建一个信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //创建一个GCD线程1
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程1");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    //创建一个GCD线程2
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程2");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    //创建一个GCD线程3
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程3");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    //创建一个group通知, 任务计数为0时自动调用
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"结束");
    });
}
```



* 这样也实现了同步实现异步线程, 可能大家会有一个疑问, 不同线程之前的信号量是否会相互干扰呢，或者说如果其中一个线程要耗费相当大的时间, 其他线程是否也会被阻塞呢, 我们来试验下, 给线程3多增加几个迭代, 然后在wait前后加上一下打印

```
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个group
    __block dispatch_group_t group = dispatch_group_create();
    
    //创建一个队列
    __block dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //创建一个信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //创建一个GCD线程1
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程1");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        NSLog(@"线程1等待");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"线程1完成");
    });
    
    //创建一个GCD线程2
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程2");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        NSLog(@"线程2等待");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"线程2完成");
        
    });
    
    //创建一个GCD线程3
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 100000; i ++) {
                for (int i = 0; i < 100000; i ++) {
                    
                }
            }
            NSLog(@"线程3");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        NSLog(@"线程3等待");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"线程3完成");
    });
    
    //创建一个group通知, 任务计数为0时自动调用
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"结束");
    });
}
```

* 运行结果为:

```
2017-01-18 17:14:58.814 GCDDemo[1136:77412] 线程2等待
2017-01-18 17:14:58.814 GCDDemo[1136:77410] 线程1等待
2017-01-18 17:14:58.814 GCDDemo[1136:77409] 线程3等待
2017-01-18 17:14:58.823 GCDDemo[1136:77339] 线程1
2017-01-18 17:14:58.823 GCDDemo[1136:77339] 线程2
2017-01-18 17:14:58.823 GCDDemo[1136:77412] 线程2完成
2017-01-18 17:14:58.823 GCDDemo[1136:77410] 线程1完成
2017-01-18 17:15:17.793 GCDDemo[1136:77339] 线程3
2017-01-18 17:15:17.793 GCDDemo[1136:77409] 线程3完成
2017-01-18 17:15:17.794 GCDDemo[1136:77409] 结束[![复制代码](https://common.cnblogs.com/images/copycode.gif)
```

* 好像看起来线程1, 2没有受到线程3的影响我们再增加线程3的耗时看看, 

```
//创建一个GCD线程3
dispatch_group_async(group, queue, ^{

    //模拟异步耗时操作
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 1000000; i ++) {
            for (int i = 0; i < 1000000; i ++) {

            }
        }
        NSLog(@"线程3");
        //完成迭代后, 增加信号量
        dispatch_semaphore_signal(semaphore);
    });

    //在迭代完成之前, 信号量等待
    NSLog(@"线程3等待");
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"线程3完成");
});
```

* 我们多运行几次, 发现会出现这样的结果

```
2017-01-18 17:24:37.975 GCDDemo[1207:83821] 线程3等待
2017-01-18 17:24:37.975 GCDDemo[1207:83829] 线程2等待
2017-01-18 17:24:37.975 GCDDemo[1207:83818] 线程1等待
2017-01-18 17:24:37.984 GCDDemo[1207:83786] 线程1
2017-01-18 17:24:37.984 GCDDemo[1207:83786] 线程2
2017-01-18 17:24:37.984 GCDDemo[1207:83821] 线程3完成
2017-01-18 17:24:37.985 GCDDemo[1207:83829] 线程2完成
```

* 线程3先打印了执行完, 所以看不同线程去侦测同一个信号量的时候是会有干扰的, 但是还是会等全部线程执行结束后才会去执行notify动作



那给每一个线程分别创建一个信号量呢?

```
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建一个group
    __block dispatch_group_t group = dispatch_group_create();
    
    //创建一个队列
    __block dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //创建一个信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(0);
    dispatch_semaphore_t semaphore3 = dispatch_semaphore_create(0);
    
    //创建一个GCD线程1
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程1");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore);
        });
        
        //在迭代完成之前, 信号量等待
        NSLog(@"线程1等待");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"线程1完成");
    });
    
    //创建一个GCD线程2
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10000; i ++) {
                
            }
            NSLog(@"线程2");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore2);
        });
        
        //在迭代完成之前, 信号量等待
        NSLog(@"线程2等待");
        dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
        NSLog(@"线程2完成");
        
    });
    
    //创建一个GCD线程3
    dispatch_group_async(group, queue, ^{
        
        //模拟异步耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 1000000; i ++) {
                for (int i = 0; i < 1000000; i ++) {
                    
                }
            }
            NSLog(@"线程3");
            //完成迭代后, 增加信号量
            dispatch_semaphore_signal(semaphore3);
        });
        
        //在迭代完成之前, 信号量等待
        NSLog(@"线程3等待");
        dispatch_semaphore_wait(semaphore3, DISPATCH_TIME_FOREVER);
        NSLog(@"线程3完成");
    });
    
    //创建一个group通知, 任务计数为0时自动调用
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"结束");
    });
}
```

多运行几次, 看起来每次都是只有线程3等待, 1, 2线程会自己正常完成

这样就OK了,  所以尽量每一个线程创建一个信号量, 避免相互干扰