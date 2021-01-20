```objectivec
operation 的executing和finished状态量需要用willChangeValueForKey/didChangeValueForKey来触发KVO消息.

在调用完NSURLConnection之后start函数就返回了, 后面就坐等connection的回调了.

在connection的didFinish或didFail回调里面设置operation的finish状态, 告诉系统operation执行完毕了.  
存在的问题是: 

如果你是在主线程调用的这个并发的operation, 那一切都是非常的perfect, 
就算你当前在操作UI也不影响operation的下载操作.

但是如果你是在子线程调用的, 或者把operation加到了非main queue, 
那么问题来了, 你会发现这货的NSURLConnection delegate不走了, what's going on here?

主要的原因也是因为本例子需要一直等待delegate的回调：
解决办法是在子线程手动开启NSRunLoop 

- (BOOL)isConcurrent 
{ 
    return YES; 
} 

- (void)start 
{ 
    [self willChangeValueForKey:@"isExecuting"]; 
    _isExecuting = YES; 
    [self didChangeValueForKey:@"isExecuting"]; 

    NSURLRequest * request = [NSURLRequest requestWithURL:imageURL]; 
    _connection = [[NSURLConnection alloc] initWithRequest:request 
                                                  delegate:self]; 
    if (_connection == nil) [self finish]; 
} 

- (void)finish 
{ 
    self.connection = nil; 

    [self willChangeValueForKey:@"isExecuting"]; 
    [self willChangeValueForKey:@"isFinished"]; 

    _isExecuting = NO; 
    _isFinished = YES; 

    [self didChangeValueForKey:@"isExecuting"]; 
    [self didChangeValueForKey:@"isFinished"]; 
} 

#pragma mark - NSURLConnection delegate 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{ 
    // to do something... 
} 

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{ 
    // to do something... 
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{ 
    [self finish]; 
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{ 
    [self finish]; 
} 

@end
```