```objectivec
// 第一行代码是创建线程（创建线程的时候，系统会在内存中给线程分配一段存储空间）
// 第二行代码是调用start方法

NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];

[thread start];
```

```objectivec
@interface NSThread : NSObject
```