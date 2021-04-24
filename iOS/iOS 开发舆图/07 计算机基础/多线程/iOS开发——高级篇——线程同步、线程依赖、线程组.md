---
title: iOS开发——高级篇——线程同步、线程依赖、线程组
tags: 多线程
categories: 技术改变世界
abbrlink: 19810
date: 2017-06-08 20:25:08
---

**前言**

对于iOS开发中的网络请求模块，AFNet的使用应该是最熟悉不过了，但你是否把握了网络请求正确的完成时机？本篇文章涉及线程同步、线程依赖、线程组等专用名词的含义，若对上述名词认识模糊，可先进行查阅理解后阅读本文。如果你也纠结于文中所述问题，可进行阅读希望对你有所帮助。大神无视勿喷。

在真实开发中，我们通常会遇到如下问题：

**一、某界面存在多个请求，希望所有请求均结束才进行某操作。**

对于这一问题的解决方案很容易想到通过线程组进行实现。代码如下：

```
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //请求1
    NSLog(@"Request_1");
});
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //请求2
    NSLog(@"Request_2");
});
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //请求3
    NSLog(@"Request_3");
});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //界面刷新
    NSLog(@"任务均完成，刷新界面");
});
```

打印如下

```
Request_2
Request_1
Request_3
任务均完成，刷新界面
```



<!-- more -->

根据打印结果观察可能并没有什么问题，但需要注意的是**Request_1、Request_2**等在真实开发中通常对应为某个网络请求。而网络请求通常为异步，那这时是否还会有同样结果呢？

口说无凭，我们将**NSLog(@"Request")**;部分替换为真正的网络请求。

对于App请求数据大部分人都会选择AFNetworking。使用AFN异步请求，请求的数据返回后，就刷新相关UI。如果某一个页面有多个网络请求，我们假设有三个请求，A、B、C，而且UI里的数据必须等到A、B、C全部完成后刷新后才显示。

这里我们书写一个网络请求通用方法，假设同时请求某新闻列表的3页数据，每页均为一个独立的网络请求。使用我们最常用的AFNet请求，方法如下（真实开发中可能为banner数据请求、主体网络请求、广告网络请求等）：

```
- (void)request_A {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"token":@"63104AB32427EBF89B957BBD1A5C5C11",
                                 @"page":@"1",
                                 @"upTime":@"desc"};
 
    [manager POST:URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
 
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *rowsDict in dict[@"rows"]) {
            NSLog(@"A___%@",rowsDict[@"title"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
    }];
}
```

**request_B、request_C**分别为请求第二页与第三页数据，这里不重复书写。为了显示更加明显，在请求中打印了对应新闻的标题内容。

运行打印如下：

```
任务均完成，刷新界面
C___搞笑，不是认真的
C___摄影 | 街拍
C___生活小窍门
C___传统中国
C___想吃的美食系列
B___时间的见证者
B___没事 来吐槽吧……
B___触动心灵的摄影
B___摄影 | 黑白印记
B___每日插画推荐
A___左爱情，右面包
A___潮我看
A___世界各国的人们怎么过情人节
A___一点创意点亮生活
A___摄影 | 随手拍
```

运行后马上接收到了线程组完成的提示，之后数据才依次请求下来，很明显三个单纯的AFNet请求已经不能满足我们的需求了。线程组完成时并没有在我们希望的时候给予通知。在真实开发中会造成的问题为多个请求均加载完成，但界面已在未得到数据前提前刷新导致界面空白。

因此对于这种问题需要另辟蹊径，这里我们就要借助GCD中的信号量**dispatch_semaphore**进行实现，即营造线程同步情况。

**dispatch_semaphore**信号量为基于计数器的一种多线程同步机制。用于解决在多个线程访问共有资源时候，会因为多线程的特性而引发数据出错的问题。

如果**semaphore**计数大于等于1，计数-1，返回，程序继续运行。如果计数为0，则等待。

**dispatch_semaphore_signal(semaphore)**为计数+1操作。**dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)**为设置等待时间，这里设置的等待时间是一直等待。我们可以通俗的理解为单柜台排队点餐，计数默认为0，每当有顾客点餐，计数+1，点餐结束-1归零继续等待下一位顾客。比较类似于NSLock。

我们将网络请求通用方法进行修改如下：

```
- (void)request_A {
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"token":@"63104AB32427EBF89B957BBD1A5C5C11",
                                 @"page":@"1",
                                 @"upTime":@"desc"};
 
    [manager POST:URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
 
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //计数+1操作
        dispatch_semaphore_signal(sema);
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *rowsDict in dict[@"rows"]) {
            NSLog(@"A___%@",rowsDict[@"title"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        dispatch_semaphore_signal(sema);
    }];
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
```

为方便阅读，伪代码如下：

```
dispatch_semaphore_t sema = dispatch_semaphore_create(0);
[网络请求:{
        成功：dispatch_semaphore_signal(sema);
        失败：dispatch_semaphore_signal(sema);
}];
dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
```

这时我们再运行程序，打印如下：

```
C___聆听的耳朵
C___家居 | 你的家里还缺点什么？
C___logo设计
C___时装
C___搞笑，不是认真的
A___左爱情，右面包
A___潮我看
A___世界各国的人们怎么过情人节
A___一点创意点亮生活
A___摄影 | 随手拍
B___时间的见证者
B___没事 来吐槽吧……
B___触动心灵的摄影
B___摄影 | 黑白印记
B___每日插画推荐
任务均完成，刷新界面
```

运行打印可见，通过信号量**dispatch_semaphore**完美的解决了此问题，并且网络请求仍为异步，不会堵塞当前主线程。

**二、某界面存在多个请求，希望请求依次执行。**

对于这个问题通常会通过线程依赖进行解决，因使用GCD设置线程依赖比较繁琐，这里通过**NSOperationQueue**进行实现，这里采用比较经典的例子，三个任务分别为下载图片，打水印和上传图片，三个任务需异步执行但需要顺序性。代码如下，下载图片、打水印、上传图片仍模拟为分别请求新闻列表3页数据。

```
//1.任务一：下载图片
NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
    [self request_A];
}];

//2.任务二：打水印
NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
    [self request_B];
}];

//3.任务三：上传图片
NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
    [self request_C];
}];

//4.设置依赖
[operation2 addDependency:operation1];      //任务二依赖任务一
[operation3 addDependency:operation2];      //任务三依赖任务二

//5.创建队列并加入任务
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
[queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
```

首先我们使用未添加信号量**dispatch_semaphore**时运行，打印如下

```
B___时间的见证者
B___没事 来吐槽吧……
B___触动心灵的摄影
B___摄影 | 黑白印记
B___每日插画推荐
A___潮我看
A___左爱情，右面包
A___世界各国的人们怎么过情人节
A___一点创意点亮生活
A___摄影 | 随手拍
C___盘
C___聆听的耳朵
C___家居 | 你的家里还缺点什么？
C___logo设计
C___时装
```

根据打印结果可见，若不对请求方法做处理，其运行结果并不是我们想要的，联系实际需求，A、B、C请求分别对应下载图片、打水印、上传图片，而此时运行顺序则为B->A->C，在未获得图片时即执行打水印操作明显是错误的。重复运行亦会出现不同结果，即请求不做处理，其结果不可控无法预测。线程依赖设置并未起到作用。

解决此问题的方法仍可通过信号量**dispatch_semaphore**进行解决。我们将请求方法替换为添加**dispatch_semaphore**限制的形式。即

```
dispatch_semaphore_t sema = dispatch_semaphore_create(0);
[网络请求:{
        成功：dispatch_semaphore_signal(sema);
        失败：dispatch_semaphore_signal(sema);
}]
dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
```

再次重复运行，我们会发现每次运行结果均一致，A、B、C三任务异步顺序执行（A->B->C）

```
A___潮我看
A___左爱情，右面包
A___世界各国的人们怎么过情人节
A___一点创意点亮生活
A___摄影 | 随手拍
B___时间的见证者
B___没事 来吐槽吧……
B___触动心灵的摄影
B___摄影 | 黑白印记
B___每日插画推荐
C___盘
C___聆听的耳朵
C___家居 | 你的家里还缺点什么？
C___logo设计
C___时装xxxxxxxxxx A___潮我看A___左爱情，右面包A___世界各国的人们怎么过情人节A___一点创意点亮生活A___摄影 | 随手拍B___时间的见证者B___没事 来吐槽吧……B___触动心灵的摄影B___摄影 | 黑白印记B___每日插画推荐C___盘C___聆听的耳朵C___家居 | 你的家里还缺点什么？C___logo设计C___时装A___潮我看``A___左爱情，右面包``A___世界各国的人们怎么过情人节``A___一点创意点亮生活``A___摄影 | 随手拍``B___时间的见证者``B___没事 来吐槽吧……``B___触动心灵的摄影``B___摄影 | 黑白印记``B___每日插画推荐``C___盘``C___聆听的耳朵``C___家居 | 你的家里还缺点什么？``C___logo设计``C___时装
```

通过重复运行打印结果可证实确实实现了我们想要的效果。这样即解决了所提出的问题二。

**后续**

在开发中我们会遇到很多需要进行线程同步或请求同步的情况。比如弹出视图设置某功能，在点击确认按钮时发生请求，在请求成功同时销毁弹出视图等，均需要保证在请求真正完成时进行下一步操作。因此把握网络请求完成的正确时机还是很有必要的。