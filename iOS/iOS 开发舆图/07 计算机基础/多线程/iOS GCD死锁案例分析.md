---
title: iOS GCD死锁案例分析
tags:
  - 死锁
  - gcd
categories: 技术改变世界
abbrlink: 56071
date: 2018-05-01 20:25:08
---

### 死锁一：

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"1========%@",[NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2========%@",[NSThread currentThread]);
    });
    NSLog(@"3========%@",[NSThread currentThread]);
}
```

* 打印

```jsx
2018-04-25 22:39:46.674860+0700 GCDCC[39201:2495255] 1========<NSThread: 0x604000071d00>{number = 1, name = main}
(lldb) 
```

* 分析：我们先做一个定义：- (void)viewDidLoad{} ---> 任务A，GCD同步函数 --->任务B。
* **汶：任务A先进入了主队列，任务B后面也加入了主队列，给任务B定义的是同步执行。所以任务B必须等待任务A执行完后，才能执行。但是任务B是在任务A中，任务A必须等任务B完成后，我才能继续做。**
* 总而言之呢，大概是这样的，首先，任务A在主队列，并且已经开始执行，在主线程打印出1===... ...，然后这时任务B被加入到主队列中，并且同步执行，这尼玛事都大了，系统说，同步执行啊，那我不开新的线程了，任务B说我要等我里面的Block函数执行完成，要不我就不返回，但是主队列说了，玩蛋去，我是串行的，你得等A执行完才能轮到你，不能坏了规矩，同时，任务B作为任务A的内部函数，必须等任务B执行完函数返回才能执行下一个任务。那就造成了，任务A等待任务B完成才能继续执行，但作为串行队列的主队列又不能让任务B在任务A未完成之前开始执行，所以任务A等着任务B完成，任务B等着任务A完成，等待，永久的等待。所以就死锁了。简单不？下面我们慎重看一下我们无意识书写的代码！

<!-- more -->

### 死锁二：

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_queue_t q = dispatch_queue_create("chuan", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(q, ^{
        NSLog(@"任务1========%@",[NSThread currentThread]);
        dispatch_sync(q, ^{
            NSLog(@"任务2========%@",[NSThread currentThread]);
        });
        dispatch_async(q, ^{
            NSLog(@"任务3========%@",[NSThread currentThread]);
        });
    });
}

// 汶：3个任务都是在同一个队列，队列接收了任务，开始分配线程给他们执行，因为是串行队列，dispatch_sync是同步，不创建线程，里面包了3个任务
```

* 打印

```jsx
2018-04-26 09:57:42.324541+0700 GCD[75126:3811592] 1========<NSThread: 0x600000073580>{number = 1, name = main}
(lldb)
```

* 分析：我们先做一个定义：- (void)viewDidLoad{} ---> 任务A，GCD同步函数 --->任务B。
* **汶：任务A需要等任务B完成后，才能完成。任务B是一个同步的串行队列，任务1执行完，到任务2。但是任务2是放到同一个队列q里面，和任务B是同级的，他们两要一起执行，任务B要执行完，必须等任务2执行完后才能接着到任务3，后才能完成，但是任务B是先进队列q的，任务2是后进队列q的，于是任务B需要先执行完，才能到任务2，可以任务2需要等任务B执行完才能开始执行，于是任务2永远无法完成，任务B也无法完成，造成循环等待。**
* 分析： 首先队列是一个串行队列，串行队列的特点，一个任务执行完毕执行下一个任务，开不开线程取决于任务是同步还是异步，开几条线程决定于是串行还是并行，此时的情况说明 任务1，任务2，任务3全部都在同一条线程上执行，并且线程是同步执行的，讲到这里我想你已经懂了，比如说任务A正在执行任务，遇到了任务B，任务A我必须要执行完我的任务，任务B你让开道，任务B是个死脑筋，会说我们两个在同一条道上，我的原则和你的原则一样，你不执行完，休想让我执行，这个时候任务A和任务B就开始了漫长的相互等待导致最后的崩溃。这个和案例一样只是可以再一次深入理解一下。

### 死锁三

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_queue_t q = dispatch_queue_create("chuan", DISPATCH_QUEUE_SERIAL);
    dispatch_async(q, ^{
        NSLog(@"1========%@",[NSThread currentThread]);
        dispatch_sync(q, ^{
            NSLog(@"2========%@",[NSThread currentThread]);
        });
        dispatch_async(q, ^{
            NSLog(@"3========%@",[NSThread currentThread]);
        });
    });
}
```

* 打印

```tsx
2018-04-26 10:14:19.802281+0700 GCD[75370:3825211] 1========<NSThread: 0x604000274b80>{number = 3, name = (null)}
(lldb) 
```

* 分析：我们先做一个定义：- (void)viewDidLoad{} ---> 任务A，GCD异步函数 --->任务B。
* 汶：
* 分析：这个案例和案例一，案例二一样，属于同一个案例，只是不同的形式dispatch_async，看到这里是不是有种666的感觉～首先 我们还是从队列开始分析，这是一个串行队列，串行队列的特点是一个任务执行完执行下一个任务，道理同案例一案例二，不解释了 兄弟们，希望帮到你们～