### OSSpinLock
1. OSSpinLock叫做 "自旋锁"，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源
2. 目前已经不再安全，可能会出现优先级反转问题
3. 如果等待锁的线程优先级较高，它会一直占用着CPU资源，优先级低的线程就无法释放锁
4. 需要导入头文件#import <libkern/OSAtomic.h>
```
//初始化锁
OSSpinLock lock = OS_SPINLOCK_INIT;
//尝试加锁(如果需要等待就不加锁，直接返回false；如果不需要等待就加锁，返回true)
bool result = OSSpinLockTry(&lock);
//加锁
OSSpinLockLock(&lock);
//解锁
OSSpinLockUnlock(&lock);
```

### os_unfair_lock

```
1. os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持
2. 从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等
3. 需要导入头文件#import <os/lock.h>
复制代码
// 初始化锁
os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
// 尝试加锁
os_unfair_lock_trylock(&lock);
// 加锁
os_unfair_lock_lock(&lock);
// 解锁
os_unfair_lock_unlock(&lock);
复制代码
```



<!-- more -->

### pthread_mutex

```
1. mutex叫做 "互斥锁"，等待锁的线程会处于休眠状态
2. 需要导入头文件#import <pthread.h>
复制代码
/*
 * Mutex type attributes
 */
#define PTHREAD_MUTEX_NORMAL		0
#define PTHREAD_MUTEX_ERRORCHECK	1
#define PTHREAD_MUTEX_RECURSIVE		2
#define PTHREAD_MUTEX_DEFAULT		PTHREAD_MUTEX_NORMAL
复制代码
// 初始化锁的属性
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
// 初始化锁
pthread_mutex_t mutex;
pthread_mutex_init(mutex, &attr);
// 尝试加锁
pthread_mutex_trylock(&mutex);
// 加锁
pthread_mutex_lock(&mutex);
// 解锁
pthread_mutex_unlock(&mutex);
// 销毁相关资源
pthread_mutexattr_destroy(&attr);
pthread_mutex_destroy(&mutex);
复制代码
```



<!-- more -->

##### pthread_mutex 递归实现

```
// 初始化锁的属性
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
// 初始化锁
pthread_mutex_t mutex;
pthread_mutex_init(mutex, &attr);
复制代码
```

##### pthread_mutex 条件实现

```
// 初始化锁
pthread_mutex_t mutex;
pthread_mutex_init(&mutex, NULL);
// 初始化条件
pthread_cond_t condition;
pthread_cond_init(condition, NULL);
// 加锁
pthread_mutex_lock(&mutex);
// 解锁
pthread_mutex_unlock(&mutex);
// 等待条件 (进入休眠，放开mutex锁；被唤醒后，会再次对mutex加锁)
pthread_cond_wait(&condition, &mutex);
// 信号激活一个等待该条件的锁
pthread_cond_signal(&condition);
// 广播激活所有等待该条件的锁
pthread_cond_broadcast(&condition);
// 销相关毁资源
pthread_mutex_destroy(&mutex);
pthread_cond_destroy(&condition);
复制代码
```

### NSLock

```
是对 pthread_mutex 的封装
复制代码
```

NSLocking协议

```
@protocol NSLocking
- (void)lock;
- (void)unlock;
@end

复制代码
@interface NSLock : NSObject <NSLocking> {
- (BOOL)tryLock;
- (BOOL)lockBeforeDate:(NSDate *)limit;
@end

// 初始化
NSLock *lock = [[NSLock alloc] init];
复制代码
```

### NSRecursiveLock

```
是对 pthread_mutex递归实现 的封装
复制代码
@interface NSRecursiveLock : NSObject <NSLocking> {
- (BOOL)tryLock;
- (BOOL)lockBeforeDate:(NSDate *)limit;
@end
// 初始化
NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
复制代码
```

### NSCondition

```
是对 pthread_mutex条件实现 的封装
复制代码
@interface NSCondition : NSObject <NSLocking> {
- (void)wait;
- (BOOL)waitUntilDate:(NSDate *)limit;
- (void)signal;
- (void)broadcast;
@end
// 初始化
NSCondition *condition = [[NSCondition alloc] init];
复制代码
```

### NSConditionLock

```
是对NSCondition的进一步封装，可以设置具体的条件值
复制代码
@interface NSConditionLock : NSObject <NSLocking> {

- (instancetype)initWithCondition:(NSInteger)condition;

@property (readonly) NSInteger condition;

- (void)lockWhenCondition:(NSInteger)condition;
- (BOOL)tryLock;
- (BOOL)tryLockWhenCondition:(NSInteger)condition;
- (void)unlockWithCondition:(NSInteger)condition;
- (BOOL)lockBeforeDate:(NSDate *)limit;
- (BOOL)lockWhenCondition:(NSInteger)condition beforeDate:(NSDate *)limit;
@end
// 初始化
  NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:1];
复制代码
```

### @synchronized

```
1. @synchronized是对mutex递归锁的封装
2. 源码查看：objc4中的objc-sync.mm文件
3. @synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁、解锁操作
复制代码
@synchronized(obj) {
   // todo
}
复制代码
```

# 信号量

### dispatch_semaphore

```
1. semaphore叫做 "信号量"
2. 信号量的初始值，可以用来控制线程并发访问的最大数量
3. 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步
复制代码
// 信号量的初始值
int value = 1;
// 初始化信号量
dispatch_semaphore_t semaphore = dispatch_semaphore_create(value);
// 如果信号量的值<=0，当前线程就会进入休眠等待(直到信号量的值>0)
// 如果信号量的值>0, 就减1，然后往下执行代码
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
// 信号量值加1 
dispatch_semaphore_signal(semaphore);
复制代码
```

# 串行队列

### dispatch_queue(DISPATCH_QUEUE_SERIAL)

```
1. 直接使用GCD的串行队列，也是可以实现线程同步的
复制代码
dispatch_queue_t queue = dispatch_queue_create("lock_queue", DISPATCH_QUEUE_SERIAL);

dispatch_sync(queue, ^{
  // todo
});
复制代码
```

# 性能比较

性能从高到低排序

1. os_unfair_lock
2. OSSpinLock
3. dispatch_semaphore
4. pthread_mutex
5. dispatch_queue(DISPATCH_QUEUE_SERIAL)
6. NSLock
7. NSCondition
8. pthread_mutex(recursive)
9. NSRecursiveLock
10. NSConditionLock
11. @synchronized

# 读写线程安全

### pthread_rwlock

```
等待锁的线程会进入休眠

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()
@property (assign, nonatomic) pthread_rwlock_t lock;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pthread_rwlock_init(&_lock, NULL);
}

- (void)read {
    pthread_rwlock_rdlock(&_lock);
    
    // do read
    pthread_rwlock_unlock(&_lock);
}

- (void)write
{
    pthread_rwlock_wrlock(&_lock);
    
  // do write
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_lock);
}
@end
```

### dispatch_barrier_async

```
1. 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的
2. 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果

dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
dispatch_async(queue, ^{
    //do read
});

dispatch_barrier_async(queue, ^{
    // do write
});
```