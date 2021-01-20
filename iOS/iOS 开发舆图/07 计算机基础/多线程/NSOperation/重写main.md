```objectivec
Operation 直接执行不需要 queue, 且是串行，如果只重写 main 方法，
因为 NSOperation 是默认非并发的，所以会 block 住该线程

- (void)main {  

    @autoreleasepool {  
        if (self.isCancelled) return;  
        if (self.isCancelled) {  
        return; }  
        NSLog(@"MAIN....");  
    }  
}  

Operation 直接执行不需要 queue, 且是并发，并发的 Operation
- (BOOL)isConcurrent {  
    return YES;  
}  

- (void)start  
{  
    [self willChangeValueForKey:@"isExecuting"];  
    // _isExecuting = YES;  
    [self didChangeValueForKey:@"isExecuting"];  
    [self finish];  
}  

- (void)finish  
{  
    [self willChangeValueForKey:@"isExecuting"];  
    [self willChangeValueForKey:@"isFinished"];  

    // _isExecuting = NO;  
    // _isFinished = YES;  

    [self didChangeValueForKey:@"isExecuting"];  
    [self didChangeValueForKey:@"isFinished"];  
}
```