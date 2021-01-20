```objectivec
Swift 中不能使用
使用的时候需要传入一个方法名
如果直接执行NSInvocationOperation中的操作，那么默认会在主线程中执行 

NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(demo) object:nil]; 

[op1 start];  

// 使用InvocationOperation 
- (void)setupJJInvocationOperation 
{ 
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil]; 
    [operation start]; 
} 

- (void)run 
{ 
    NSLog(@"setupJJInvocationOperation %@", [NSThread currentThread]); 
}
```