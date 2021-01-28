主线程延迟

// 【主线程】：延迟2秒后执行1次 
- (void)setupMainThreadDelayInSecond:(float)second{ 
    double delayInSeconds = second; 
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); 
    dispatch_after(time, dispatch_get_main_queue(), ^(void){ 
        // 执行事件 
        NSLog(@"setupMainThreadDelayInSecond------------%@", [NSThread currentThread]); 
    }); 
} 
 

子线程延迟

// 【子线程】：延迟2秒后执行1次 
- (void)setupSonThreadDelayInSecond:(float)second{ 
    double delayInSeconds = second; 
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); 
    dispatch_after(time, dispatch_get_global_queue(0, 0), ^(void){ 
        // 执行事件 
        NSLog(@"setupSonThreadDelayInSecond------------%@", [NSThread currentThread]); 
    }); 
} 