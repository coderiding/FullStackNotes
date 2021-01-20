### **死锁例子1**

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"1");
    // 同步+主队列（无子线程）
    // 任务一个个执行（主队列）
    dispatch_sync(dispatch_get_main_queue(),^{
        NSLog(@"1");
    });
    NSLog(@"3");
}
```

- 上面打印的结果是：只打印出1，然后卡死
- 分析：我们先做一个定义：- (void)viewDidLoad{} ---> 任务A，GCD同步函数 --->任务B。
- **汶：任务A先进入了主队列，任务B后面也加入了主队列，给任务B定义的是同步执行。所以任务B必须等待任务A执行完后，才能执行。但是任务B是在任务A中，任务A必须等任务B完成后，我才能继续做。**

### **死锁例子2**

```objectivec
// DISPATCH_QUEUE_SERIAL表示任务一个执行（串行）
dispatch_queue_t serialQueue = dispatch_queue_create("test",DISPATCH_QUEUE_SERIAL);
// 异步+串行队列（一个子线程）
dispatch_async(serialQueue,^{
    // 同步+串行队列（无子线程）
    dispatch_sync(serialQueue,^{
        NSLog(@"deadLock");
    }); 
}
```

### **死锁例子3**

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
```

- 汶：3个任务都是在同一个队列，队列接收了任务，开始分配线程给他们执行，因为是串行队列，dispatch_sync是同步，不创建线程，里面包了3个任务
- 分析：我们先做一个定义：- (void)viewDidLoad{} ---> 任务A，GCD同步函数 --->任务B。
- **汶：任务A需要等任务B完成后，才能完成。任务B是一个同步的串行队列，任务1执行完，到任务2。但是任务2是放到同一个队列q里面，和任务B是同级的，他们两要一起执行，任务B要执行完，必须等任务2执行完后才能接着到任务3，后才能完成，但是任务B是先进队列q的，任务2是后进队列q的，于是任务B需要先执行完，才能到任务2，可以任务2需要等任务B执行完才能开始执行，于是任务2永远无法完成，任务B也无法完成，造成循环等待。**

### **死锁例子4**

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

- 分析：我们先做一个定义：- (void)viewDidLoad{} ---> 任务A，GCD异步函数 --->任务B。