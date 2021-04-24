---
title: iOS 多线程GCD-栅栏函数 dispatch_barrier_sync和dispatch_barrier_async
tags:
  - 多线程
  - 栅栏
  - 多任务
  - 依赖
categories: 技术改变世界
abbrlink: 61291
date: 2018-03-20 11:12:12
---



> 栅栏使用场景：当我们的任务有依赖关系的时候，比如任务1和2执行完毕后才能执行任务3和4，这时候我们可以用到这个函数——栅栏函数。其中 queue 是队列，block 是任务。



### 栅栏使用原理

- **同步栅栏**：提交一个栅栏函数在执行中,它会等待栅栏函数执行完再去执行下一行代码（注意是下一行代码），同步栅栏函数是在主线程中执行的```dispatch_barrier_sync(dispatch_queue_t queue, dispatch_block_t blcok);```
  -  同步栅栏添加进入队列的时候，当前线程会被锁死，直到同步栅栏之前的任务和同步栅栏任务本身执行完毕时，当前线程才会打开然后继续执行下一句代码。
- **异步栅栏**：提交一个栅栏函数在异步执行中,它会立马返回开始执行下一行代码（不用等待任务执行完毕）
   ```dispatch_barrier_async(dispatch_queue_t queue, dispatch_block_t blcok);```
- 共同点
  - 都会等待在它前面插入队列的任务（0、1、2）先执行完
  - 都会等待他们自己的任务（barrier）执行完再执行后面的任务（3、4、5）（注意这里说的是任务不是下一行代码）
- 不同点
  - dispatch_barrier_sync需要等待自己的任务（barrier）结束之后，才会继续添加并执行写在barrier后面的任务（3、4、5），然后执行后面的任务
  - dispatch_barrier_async将自己的任务（barrier）插入到queue之后，不会等待自己的任务结束，它会继续把后面的任务（3、4、5）插入到queue，然后执行任务。

### 栅栏使用注意

* 在使用栅栏函数时.使用**自定义队列**才有意义,如果用的是串行队列或者系统提供的全局并发队列,这个栅栏函数的作用等同于一个同步函数的作用

<!-- more -->

```objectivec
//并发队列   栅栏函数
- (void)concurrentQueueAsyncAndSync2BarrrierTest
 {
     dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);

     dispatch_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"任务0 %d",i);
         }];
     });

     dispatch_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"任务1 %d",i);
         }];
     });

     NSLog(@"同步栅栏 start😊");
     dispatch_barrier_sync(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"同步栅栏, %@",[NSThread currentThread]);
         }];
     });
     NSLog(@"同步栅栏 end😊");

     dispatch_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"任务2 %d",i);
         }];
     });

     dispatch_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"任务3 %d",i);
         }];
     });

     NSLog(@"异步栅栏 start 😄");
     dispatch_barrier_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"异步栅栏 %@",[NSThread currentThread]);
         }];
     });

     NSLog(@"异步栅栏 end 😄");
     dispatch_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"任务4 %d",i);
         }];
     });

     dispatch_async(concurrentQueue, ^{
         [self forNumIncrementCondition:5 actionBlock:^(int i) {
             NSLog(@"任务5 %d",i);
         }];
     });

}

- (void)forNumIncrementCondition:(NSUInteger )num  actionBlock:(void(^)(int i))actionBlcok
{
     for (int a = 0; a < num; a ++)
     {
         if (actionBlcok) {
             actionBlcok(a);
         }
     }
}
 
```

* 打印结果如下

```tsx
 [5141:1319243] 同步栅栏 start😊
 [5141:1319371] 任务0 0
 [5141:1322592] 任务1 0
 [5141:1319371] 任务0 1
 [5141:1322592] 任务1 1
 [5141:1319371] 任务0 2
 [5141:1322592] 任务1 2
 [5141:1319371] 任务0 3
 [5141:1322592] 任务1 3
 [5141:1319371] 任务0 4
 [5141:1322592] 任务1 4
 [5141:1319243] 同步栅栏, <NSThread: 0x60800006f300>{number = 1, name = main}
 [5141:1319243] 同步栅栏, <NSThread: 0x60800006f300>{number = 1, name = main}
 [5141:1319243] 同步栅栏, <NSThread: 0x60800006f300>{number = 1, name = main}
 [5141:1319243] 同步栅栏, <NSThread: 0x60800006f300>{number = 1, name = main}
 [5141:1319243] 同步栅栏, <NSThread: 0x60800006f300>{number = 1, name = main}
 [5141:1319243] 同步栅栏 end😊
 [5141:1319243] 异步栅栏 start 😄
 [5141:1319371] 任务3 0
 [5141:1322592] 任务2 0
 [5141:1319243] 异步栅栏 end 😄
 [5141:1319371] 任务3 1
 [5141:1322592] 任务2 1
 [5141:1319371] 任务3 2
 [5141:1322592] 任务2 2
 [5141:1319371] 任务3 3
 [5141:1322592] 任务2 3
 [5141:1319371] 任务3 4
 [5141:1322592] 任务2 4
 [5141:1322592] 异步栅栏 <NSThread: 0x60c00046dbc0>{number = 5, name = (null)}
 [5141:1322592] 异步栅栏 <NSThread: 0x60c00046dbc0>{number = 5, name = (null)}
 [5141:1322592] 异步栅栏 <NSThread: 0x60c00046dbc0>{number = 5, name = (null)}
 [5141:1322592] 异步栅栏 <NSThread: 0x60c00046dbc0>{number = 5, name = (null)}
 [5141:1322592] 异步栅栏 <NSThread: 0x60c00046dbc0>{number = 5, name = (null)}
 [5141:1322592] 任务4 0
 [5141:1319371] 任务5 0
 [5141:1322592] 任务4 1
 [5141:1319371] 任务5 1
 [5141:1322592] 任务4 2
 [5141:1319371] 任务5 2
 [5141:1322592] 任务4 3
 [5141:1319371] 任务5 3
 [5141:1322592] 任务4 4
 [5141:1319371] 任务5 4
 
```

