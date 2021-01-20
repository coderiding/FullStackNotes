```objectivec
-(void)start;// 启动任务,默认在当前队列同步执行；当实现了start方法时，默认会执行start方法，而不执行main方法 

-(void)main;//main 函数执行完成后, isExecuting会被置为NO, 而isFinished则被置为YES. 

-(void)addDependency:(NSOperation *)op;// 依赖可以跨队列依赖 

-(void)removeDependency:(NSOperation *)op; 

-(void)cancel;// 取消任务，GCD没有这个功能 

-(void)waitUntilFinished ; 

-(void)addExecutionBlock:(void (^)(void))block;// 参考《NSOperation【子类1：NSBlockOperation】》 

-(nullable instancetype)initWithTarget:(id)target selector:(SEL)sel object:(nullable id)arg; 

-(instancetype)initWithInvocation:(NSInvocation *)inv NS_DESIGNATED_INITIALIZER; 

-(void)addOperation:(NSOperation *)op;// 添加任务 

-(void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait ;// 添加任务 

-(void)addOperationWithBlock:(void (^)(void))block ;// 添加任务 

-(void)cancelAllOperations;// 取消队列中所有的任务 

-(void)waitUntilAllOperationsAreFinished;// 阻塞当前线程直到此队列中的所有任务执行完毕 

+(nullable NSOperationQueue *)currentQueue ; 

+(NSOperationQueue *)mainQueue ;// 获取主队列 

+(instancetype)blockOperationWithBlock:(void (^)(void))block; 

@property NSInteger maxConcurrentOperationCount;// 最大并发数;用来设置最多可以让多少个任务同时执行;为 1 时为串行；主对列默认是串行队列 

@property (readonly) NSUInteger operationCount;// 获取队列的任务数 

@property (readonly, getter=isCancelled) BOOL cancelled;// 取消；用KVO可以方便的监测NSOperation的状态(isExecuted, isFinished, isCancelled) 

@property (readonly, getter=isExecuting) BOOL executing;// 正在执行；因为都起了别名，所以可以通过 isExecuting 来 getter 属性值 

@property (readonly, getter=isFinished) BOOL finished;// 完成 

@property (getter=isSuspended) BOOL suspended;// 暂停;[queue setSuspended:YES];是重写 set 方法 

NSOperationQueuePriority 

- NSOperationQueuePriorityVeryLow = -8L, 
- NSOperationQueuePriorityLow = -4L, 
- NSOperationQueuePriorityNormal = 0, 
- NSOperationQueuePriorityHigh = 4, 
- NSOperationQueuePriorityVeryHigh = 8
```