---
title: GCD如何控制最大并发数
tags: 多线程
categories: 技术改变世界
abbrlink: 61468
date: 2018-07-20 12:25:08
---

使用信号量控制最多可并发执行的任务，具体实现可参考：

```
void dispatch_asyn_limit_3(dispatch_queue_t queue, dispatch_block_t block){
    //控制并发数的信号量
    static dispatch_semaphore_t limitSemaphore;
    //专门控制并发等待的线程
    static dispatch_queue_t receiveQueue;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitSemaphore = dispatch_semaphore_create(3);
        receiveQueue = dispatch_queue_create("receiver", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(receiveQueue, ^{
        //若信号量小于0，则会阻塞receiveQueue的线程，控制添加到queue里的任务不会超过三个。
        dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            if (block) {
                block();
            }
            //block执行完后增加信号量
            dispatch_semaphore_signal(limitSemaphore);
        })
    });
    // 并发任务先异步派发到receiveQueue串行队列，该队列用来保存这些任务
    // 为什么是异步派发？
    //  dispatch_async表示不需要等到block执行完即可继续向下执行（执行下一条语句）
    //  如果使用dispatch_sync则需要等到block执行完才能继续向下执行，
    //  也就意味着如果dispatch_semaphore_wait方法被阻塞（信号量减为0）则该方法会被阻塞
    // receiveQueue可以是并行队列吗？
    //  派发到串行队列的任务需要等到前一个执行完成后，后一个才能开始执行
    //  而并发队列不需要等到前一个执行完成，只要前一个开始执行，后一个就可以开始
    //  如果使用并发队列，则超出最大并发数任务都会在dispatch_semaphore_wait处阻塞
    //  这会导致占用多个线程。
}
```