```objectivec
AFNetworking 源代码 
+ (void)networkRequestThreadEntryPoint:(id)__unused object 
{ 
    @autoreleasepool { 
        [[NSThread currentThread] setName:@"AFNetworking"]; 
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop]; 
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode]; 
        [runLoop run]; 
    } 
} 
+ (NSThread *)networkRequestThread 
{ 
    static NSThread *_networkRequestThread = nil; 
    static dispatch_once_t oncePredicate; 
    dispatch_once(&oncePredicate, ^{ 
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil]; 
        [_networkRequestThread start]; 
    }); 
    return _networkRequestThread; 
} 
- (void)start 
{ 
    [self.lock lock]; 
    if ([self isCancelled]) { 
        [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]]; 
    } else if ([self isReady]) { 
        self.state = AFOperationExecutingState; 
        [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]]; 
    } 
    [self.lock unlock]; 
} 

代码参考 

- (void)start 
{ 
    if (![NSThread isMainThread]) { 
        [self performSelectorOnMainThread:@selector(start) 
                               withObject:nil 
                            waitUntilDone:NO]; 
        return; 
    } 
    // set up NSURLConnection... 
} 
或者这样: 
- (void)start 
{ 
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{ 
        self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self]; 
    }]; 
}
```