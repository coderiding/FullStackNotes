---
title: GCD信号量-dispatch_semaphore_t
tags: 多线程
categories: 技术改变世界
abbrlink: 43980
date: 2018-01-20 12:25:08
---

### 1.GCD信号量简介

GCD信号量机制主要涉及到以下三个函数：

```cpp
dispatch_semaphore_create(long value); // 创建信号量
dispatch_semaphore_signal(dispatch_semaphore_t deem); // 发送信号量
dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout); // 等待信号量
```

`dispatch_semaphore_create(long value);`和GCD的group等用法一致，这个函数是创建一个dispatch_semaphore_类型的信号量，并且创建的时候需要指定信号量的大小。

 `dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);` 等待信号量。该函数会对信号量进行减1操作。如果减1后信号量小于0（即减1前信号量值为0），那么该函数就会一直等待，也就是不返回（相当于阻塞当前线程），直到该函数等待的信号量的值大于等于1，该函数会对信号量的值进行减1操作，然后返回。

 `dispatch_semaphore_signal(dispatch_semaphore_t deem);` 发送信号量。该函数会对信号量的值进行加1操作。

通常等待信号量和发送信号量的函数是成对出现的。并发执行任务时候，在当前任务执行之前，用`dispatch_semaphore_wait`函数进行等待（阻塞），直到上一个任务执行完毕后且通过`dispatch_semaphore_signal`函数发送信号量（使信号量的值加1），`dispatch_semaphore_wait`函数收到信号量之后判断信号量的值大于等于1，会再对信号量的值减1，然后当前任务可以执行，执行完毕当前任务后，再通过`dispatch_semaphore_signal`函数发送信号量（使信号量的值加1），通知执行下一个任务......如此一来，通过信号量，就达到了并发队列中的任务同步执行的要求。

### 2.用信号量机制使异步线程完成同步操作

众所周知，并发队列中的任务，由异步线程执行的顺序是不确定的，两个任务分别由两个线程执行，很难控制哪个任务先执行完，哪个任务后执行完。但有时候确实有这样的需求：两个任务虽然是异步的，但仍需要同步执行。这时候，GCD信号量就可以大显身手了。

<!-- more -->

#### 2.1异步函数+并发队列 实现同步操作

当然，有人说，想让多个任务同步执行，干嘛非要用异步函数+并发队列呢？
 当然，我们也知道异步函数 + 串行队列实现任务同步执行更加简单。不过异步函数 + 串行队列的弊端也是非常明显的：因为是异步函数，所以系统会开启新（子）线程，又因为是串行队列，所以系统只会开启一个子线程。这就导致了所有的任务都是在这个子线程中同步的一个一个执行。丧失了并发执行的可能性。虽然可以完成任务，但是却没有充分发挥CPU多核（多线程）的优势。

```objectivec
    // 串行队列 + 异步（异步表示会创建线程,创建几个，取决于是什么队列） == 只会开启一个线程，且队列中所有的任务都是在这个线程执行（每个人物都是顺序执行）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // DISPATCH_QUEUE_SERIAL 表示串行队列
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
  
  	// dispatch_async表示异步
    dispatch_async(queue, ^{
        NSLog(@"111:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"222:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"333:%@",[NSThread currentThread]);
    });
}
```

以上三个任务的执行顺序永远是任务1、任务2、任务3，且永远是在同一个子线程被执行。如下图（1、2、3、4、5、6）：

![Xnip2020-10-29_10-57-45](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_10-57-45.jpg)



#### 2.2 用GCD的信号量来实现异步线程同步操作

```objectivec
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  	// 创建信号量
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
  
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"任务1:%@",[NSThread currentThread]);
      	// 信号量加1
        dispatch_semaphore_signal(sem);
    });
    
    // 信号量减1
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务2:%@",[NSThread currentThread]);
        // 信号量加1
        dispatch_semaphore_signal(sem);
    });
    
    // 信号量减1
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务3:%@",[NSThread currentThread]);
    });
}
```

其执行顺序如下图：

![Xnip2020-10-29_10-58-56](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_10-58-56.jpg)

执行结果如下图：

![Xnip2020-10-29_10-59-28](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_10-59-28.jpg)

通过上面的例子，可以得出结论：

> 一般情况下，发送信号和等待信号是成对出现的。也就是说，一个`dispatch_semaphore_signal(sem);`对应一个`dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);`
>  我们注意到：使用信号量实现异步线程同步操作时，虽然任务是一个接一个被同步（说同步并不准确）执行的，但因为是在并发队列，并不是所有的任务都是在同一个线程执行的（所以说同步并不准确）。上图中绿框中的任务2是在线程5中被执行的，而任务1和任务3是在线程4中被执行的。这有别于异步函数+串行队列的方式（异步函数+ 串行队列的方式中，所有的任务都是在同一个新线程被串行执行的）。
>  在此总结下，同步和异步决定了是否开启新线程（或者说是否具有开启新线程的能力），串行和并发决定了任务的执行方式——串行执行还是并发执行（或者说开启多少条新线程）

------

例如以下情况，分别执行两个异步的AFN网络请求，第二个网络请求需要等待第一个网络请求响应后再执行，使用信号量的实现：

```objectivec
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *urlString1 = @"/Users/ws/Downloads/Snip20161223_20.png";
    NSString *urlString2 = @"/Users/ws/Downloads/Snip20161223_21.png";
    // 创建信号量
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
  
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString1 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"1完成！");
            // 发送信号量
            dispatch_semaphore_signal(sem);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"1失败！");
            // 发送信号量
            dispatch_semaphore_signal(sem);
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 等待信号量（20210407汶：上面的代码一路下来，遇到wait会卡着，直到第一个请求中执行dispatch_semaphore_signal发出信号量）
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
      
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString2 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"2完成！");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"2失败！");
        }];
    });
}
```

![Xnip2020-10-29_11-00-12](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-00-12.jpg)

### 3.用信号量和异步组实现异步线程同步执行（汶：这里和上面有点重复，可能是从哪里摘录的）

#### 3.1.异步组的常见用法

使用异步组(dispatch Group)可以实现在同一个组内的内务执行全部完毕之后再执行最后的处理。但是同一组内的block任务的执行顺序是不可控的。如下：

```cpp
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2");
    });
    dispatch_group_async(group, queue, ^{
        // 执行完毕这里的代码，是系统过一次吗，如果是网络请求，可以实现等到网络请求完毕之后，才去执行dispatch_group_notify
        NSLog(@"3");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
}
```

执行结果：

![Xnip2020-10-29_11-00-44](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-00-44.jpg)

利用异步函数，向全局并发队列追加处理，block的回调是异步的，多个线程并行执行导致追加的block任务处理顺序变化无常，但是执行结果的done肯定是在group内的三个任务执行完毕后在执行。

------

#### 3.2.信号量+异步组

上面的情况是使用异步函数并发执行三个任务，有时候我们希望使用异步函数并发执行完任务之后再异步回调到当前线程。当前线程的任务执行完毕后再执行最后的处理。这种**异步的异步**，只使用dispatch group是不够的，还需要dispatch_semaphore_t（信号量）的加入。

在没有信号量的情况下：

```objectivec
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_group_t grp = dispatch_group_create();
  
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task1 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task1 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task2 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task2 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_notify(grp, dispatch_get_main_queue(), ^{
        NSLog(@"refresh UI");
    });
}
```

执行结果

![Xnip2020-10-29_11-01-08](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-01-08.jpg)





* 在有信号量的情况下：

```objectivec
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_group_t grp = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
      
        NSLog(@"task1 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task1 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
  
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSLog(@"task2 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task2 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(grp, dispatch_get_main_queue(), ^{
        NSLog(@"refresh UI");
    });
}
```

![Xnip2020-10-29_11-01-44](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-01-44.jpg)
![Xnip2020-10-29_11-01-56](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-01-56.jpg)

如上图

虽然我们把两个任务（假设每个任务都叫做T）加到了异步组中，但是每个任务T又都有一个异步回调T'(这个异步的回调T'操作并不会立即触发，如果T'是一个网络请求的异步回调，这个回调的时机取决于网络数据返回的时间，有可能很快返回，有可能很久返回)，相当于每个任务T又都有自己的任务T'，加起来就是4个任务。因为异步组只对自己的任务T（block）负责，并不会对自己任务的任务T'（block中的block）负责，异步组把自己的任务执行完后会立即返回，并不会等待自己的任务的任务执行完毕。显然，上面这种在异步组中再异步的执行顺序是不可控的。
 不明白的请看下图：

![Xnip2020-10-29_11-02-25](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-02-25.jpg)

任务T和任务T'的关系

再不明白请看实例:
 例如以下情况：使用线程组异步并发执行两个AFN网络请求，然后网络请求不管成功或失败都会各自回调主线程去执行success或者failure的block中的任务。等到都执行完网络请求的block中的异步任务后，再发出notify，通知第三个任务，也就是说，第三个任务依赖于前两个网络请求的**异步回调**执行完毕（`注意不是网络请求，而是网络请求的异步回调，注意区分网络请求和网络请求的异步回调，网络请求是一个任务，网络请求的异步回调又是另一个任务，因为是异步，所以网络请求很快就结束了，而网络请求的异步回调是要等待网络响应的`）。但两个网络请求的异步回调的执行顺序是随机的，即，有可能是第二个网络请求先执行block回调，也有可能是第一个网络请求先执行block回调。

```objectivec
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *appIdKey = @"8781e4ef1c73ff20a180d3d7a42a8c04";
    NSString* urlString_1 = @"http://api.openweathermap.org/data/2.5/weather";
    NSString* urlString_2 = @"http://api.openweathermap.org/data/2.5/forecast/daily";
    NSDictionary* dictionary =@{@"lat":@"40.04991291",
                                @"lon":@"116.25626162",
                                @"APPID" : appIdKey};
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_1
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"1任务成功");
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"1任务失败");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore);
             }];
        // 在网络请求任务成功/失败之前，一直等待信号量（相当于阻塞，不会执行下面的操作）
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    // 将第二个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_2
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"2任务成功");
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"2任务失败");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore);
             }];
        // 在网络请求任务成功/失败之前，一直等待信号量（相当于阻塞，不会执行下面的操作）
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1和2已经完成，执行任务3。");
    });
}
```

上面代码两个线程各自创建了一个信号量，所以任务1和任务2的执行顺序具有随机性，而任务3的执行肯定会是在任务1和任务2执行完毕之后再执行。如下图：

![Xnip2020-10-29_11-02-54](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-02-54.jpg)

![Xnip2020-10-29_11-03-37](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-03-37.jpg)

其实，这种操作也可以用dispatch_group_enter(dispatch_group_t group) 和 dispatch_group_leave(dispatch_group_t group)来实现：

```objectivec
 dispatch_group_t group =dispatch_group_create();
 dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);

 dispatch_group_enter(group);

 //模拟多线程耗时操作
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
     dispatch_async(globalQueue, ^{
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"%@---block1结束。。。",[NSThread currentThread]);
             dispatch_group_leave(group);
         });
     });
     NSLog(@"%@---1结束。。。",[NSThread currentThread]);
 });

 dispatch_group_enter(group);
 //模拟多线程耗时操作
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
     dispatch_async(globalQueue, ^{
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"%@---block2结束。。。",[NSThread currentThread]);
             dispatch_group_leave(group);
         });
     });
     NSLog(@"%@---2结束。。。",[NSThread currentThread]);
 });

 dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
     NSLog(@"%@---全部结束。。。",[NSThread currentThread]);
 });
```

![Xnip2020-10-29_11-04-19](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-04-19.jpg)

如上图，使用dispatch_group_enter()和dispatch_group_leave()函数后，我们也能保证dispatch_group_notify()中的任务总是在最后被执行。
 另外，我们必须保证dispatch_group_enter()和dispatch_group_leave()是成对出现的，不然dispatch_group_notify()将永远不会被调用。

------

### 4.利用dispatch_semaphore_t将数据追加到数组

```objectivec
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:100];
    // 创建为1的信号量
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    for (int i = 0; i < 10000; i++) {
        dispatch_async(queue, ^{
            // 等待信号量
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            [arrayM addObject:[NSNumber numberWithInt:i]];
            NSLog(@"%@",[NSNumber numberWithInt:i]);
            // 发送信号量
            dispatch_semaphore_signal(sem);
        });
    }
```

使用并发队列来更新数组，如果不使用信号量来进行控制，很有可能因为内存错误而导致程序异常崩溃。如下：

![Xnip2020-10-29_11-05-42](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-29_11-05-42.jpg)

### 5.工作中信号量应用

一般情况下，-(NSString *)getSSKToken会立即返回。但加入了信号量，就会阻塞住当前线程，直到网络返回后，这个方法才返回。这是因为当时业务需要而产生的一种特殊的应用场景。正常情况下，不建议大家这样操作，否则很容易阻塞住主线程。关于信号量的应用常见于上面提到的和异步组的搭配使用。

```objectivec
- (NSString *)getSSOToken {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [AlilangSDK sharedSDKInstance].accessToken;
    if (!accessToken) {
        return nil;
    }
  
    NSString *urlString = [NSString stringWithFormat:@"%@?appcode=%@&accesstoken=%@",SSO_TOKEN_URL,ALY_BUCAPPCODE,accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
  
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
  
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          
            self.SSOTokenDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            ALYLog(@"dict == %@",self.SSOTokenDictionary);
          
        });
      
        dispatch_semaphore_signal(sem);
    }];
    [task resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return [self.SSOTokenDictionary objectForKey:SSO_TOKEN];
}
```



### 需要补充的知识点

* ？怎么计算信号量
* ？信号量1、2、3表示什么意思？
* ？如何处理各个线程之间的相互制约关系？
* ？场景：通过信号量控制最多几个线程同时执行（常见的信号量的应用场景）
* ？场景：通过信号量控制异步任务同步执行（常见的信号量的应用场景）
* ？场景：加锁(互斥)

```
// 创建信号量为1的信号时，一次只能一个线程执行，可当做锁使用（可参考SDWebImage）
_semaphore = dispatch_semaphore_create(1);

// 调用dispatch_semaphore_wait：如果当前信号量大于0则使信号量-1后执行子线程任务；当前信号量为0则等待信号量
dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

// 增加计数信号量。如果前一个值小于零，此函数将唤醒当前在wait中线程
dispatch_semaphore_signal(self.semaphore);
```



* **场景：通过信号量控制最多几个线程同时执行**

```
   // 这里的value控制基于semaphore这个信号量的相关线程最多几个线程并发运行
   // 20210407 下面的代码可以用纸最多3个线程同时执行
   
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < 10000; i++) {
        //线程1
        dispatch_async(quene, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                NSLog(@"%@",[NSString stringWithFormat:@"thread1 start%d",i]);
            sleep(2.0);
            NSLog(@"%@",[NSString stringWithFormat:@"thread1 finish%d",i]);
            dispatch_semaphore_signal(semaphore);
        });

    }
```



* **场景：加锁(互斥)**

```
//
//  ViewController.m
//  semaphoreTest2
//
//  Created by huangxianchao on 17/05/2017.
//  Copyright © 2017 黄先超. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/// iphone的数量
@property (nonatomic,assign) int iphoneNumber;
/// 互斥用的信号量
@property (nonatomic,strong) dispatch_semaphore_t semaphore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iphoneNumber = 1000;
    // 初始化1个信号量
    self.semaphore = dispatch_semaphore_create(1);
    
    /// 通过信号量进行互斥，开启三个窗口(线程)同时卖iphone
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    thread1.name = @"窗口1";
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    thread2.name = @"窗口2";
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    thread3.name = @"窗口3";
    
    /// 通过同步锁进行互斥，开启三个窗口(线程)同时卖iphone
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
//    thread1.name = @"窗口1";
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
//    thread2.name = @"窗口2";
//    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
//    thread3.name = @"窗口3";
    [thread1 start];
    [thread2 start];
    [thread3 start];
}

/// 通过信号量达到互斥
- (void)sellIphone
{
    while (1) {
        // P操作对信号量进行减一，然后信号量变0，限制其他窗口(线程)进入
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        if (self.iphoneNumber > 0) // 检查还有没iphone可卖
        {
            NSLog(@"卖出iphone剩下%d台iphone",--self.iphoneNumber);
            
        }
        else
        {
            NSLog(@"iphone没有库存了");
            return;
        }
        
        // V操作对信号量进行加一，然后信号量为1，其他窗口(线程)就能进入了
        dispatch_semaphore_signal(self.semaphore);
    }
}

/// 通过同步锁进行互斥，通过同步锁会比通过信号量控制的方式多进入该临界代码（线程数量-1）次
- (void)sellIphoneWithSynchronization
{
    while (1) {
        
        @synchronized (self) {
            if (self.iphoneNumber > 0) // 检查还有没iphone可卖
            {
                NSLog(@"%@卖出iphone剩下%d台iphone",[NSThread currentThread].name,--self.iphoneNumber);
            }
            else
            {
                NSLog(@"iphone没有库存了");
                return;
            }

        }
    }
}


@end

```

