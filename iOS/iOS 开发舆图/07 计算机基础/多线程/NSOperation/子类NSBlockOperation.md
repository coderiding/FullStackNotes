```objectivec
通过这个方法可以给 Operation 添加多个执行Block，这样Operation中的任务会并发执行，
它会在主线程和其它的多个线程执行这些任务

如果只封装一个操作，那么默认就会在主线程中执行

如果封装了多个操作，那么除了第一个操作以外，其他的操作会在子线程执行

注意：addExecutionBlock 方法必须在 start() 方法之前执行，否则就会报错：

NSOperation 默认是非并发的（non-concurrent），就是说把operation放到某个线程执行，
会一直block住该线程，直到operation finished

对于非并发的operation只需要继承NSOperation，重写main()方法 

基本语法 
NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{ 
    //CODE 
}]; 

[operation start]; 

------------------------

通过这个方法可以给 Operation 添加多个执行 Block ，这样 Operation 中的任务会并发执行，它会在主线程和其它的多个线程执行这些任务
如果只封装一个操作，那么默认就会在主线程中执行
如果封装了多个操作，那么除了第一个操作以外，其他的操作会在子线程执行
注意： addExecutionBlock 方法必须在 start() 方法之前执行，否则就会报错：
NSOperation 默认是非并发的（ non-concurrent ），就是说把 operation 放到某个线程执行，会一直 block 住该线程，直到 operation finished
对于非并发的 operation 只需要继承 NSOperation ，重写 main() 方法

基本语法  
NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{  
     //CODE  
}];  
[operation start];

--------------------------  
单个操作

- (void)setupJJBlockOperation{  
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{  
    NSLog(@"setupJJBlockOperation %@", [NSThread currentThread]);  
    }];  
    [operation start];  
}  

-------------------------- 
多个操作

- (void)setupJJBlockOperationMore  
{  
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@"%@", [NSThread currentThread]);  
    }];  

    for (NSInteger i = 0; i < 5; i++) {// 添加多个 Block  
        [operation addExecutionBlock:^{  
            NSLog(@" 第 %ld 次： %@", i, [NSThread currentThread]);// 会在不同线程执行  
        }];  
    }  

    [operation start];  
}  

-------------------------- 
添加到主队列

// 任务被添加到主队列  
- (void)setupJJMainQueueOperation  
{  
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@"setupJJMainQueueOperation %@", [NSThread currentThread]);  
    }];  
    [[NSOperationQueue mainQueue] addOperation:operation];// 主队列 == 串行队列  
}  

-------------------------- 
添加到并发队列

// 任务被添加到并发队列  
- (void)setupJJQueueOperation  
{  
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@"setupJJQueueOperation %@", [NSThread currentThread]);  
    }];  
    [[[NSOperationQueue alloc] init] addOperation:operation];// 并发队列  
}  

-------------------------- 
例 1

//1 、将操作封装到 Operation 中  
NSBlockOperation*op = [NSBlockOperation blockOperationWithBlock:^{  
    NSLog(@"1 - %@",[NSThread currentThread]);  
}];  

//2 、添加操作  
// 如果只封装了一个操作，那么默认会在主线程执行  
// 如果封装了多个操作，那么除了第一个操作以外，其他的操作会在子线程执行  
[op addExecutionBlock:^{  
    NSLog(@"2 - %@",[NSThread currentThread]);  
}];  

[op addExecutionBlock:^{  
    NSLog(@"3 - %@",[NSThread currentThread]);  
}];  

-------------------------- 
例 2

NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{  
    NSLog(@"%@", [NSThread currentThread]);  
}];  

for (NSInteger i = 0; i < 5; i++) {// 添加多个 Block  
    [operation addExecutionBlock:^{  
        NSLog(@" 第 %ld 次： %@", i, [NSThread currentThread]);// 会在不同线程执行  
    }];  
}  

[operation start];
```