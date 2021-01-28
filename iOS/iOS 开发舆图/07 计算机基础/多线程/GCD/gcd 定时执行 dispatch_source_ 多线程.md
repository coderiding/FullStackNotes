主线程定时执行

@property (nonatomic, strong) dispatch_source_t timer; 

// 【主线程】：2秒后隔2秒执行1次共执行多次 
- (void)setupMainThreadJJGCDTimerWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount 
{ 
    dispatch_queue_t queue = dispatch_get_main_queue(); 
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue); 
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC)); 
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC); 
    dispatch_source_set_timer(self.timer, start, interval, 0); 
    __block int count = 0; 

    dispatch_source_set_event_handler(self.timer, ^{ 
        // 执行事件 
        NSLog(@"setupMainThreadJJGCDTimerWithStartTimeSinceNow------------%@", [NSThread currentThread]); 
        count++; 
        if (count == repeatcount) { 
            dispatch_cancel(self.timer); 
            self.timer = nil; 
        } 

    }); 
    dispatch_resume(self.timer); 
} 

 


子线程定时执行

@property (nonatomic, strong) dispatch_source_t timer; 

// 【子线程】：2秒后隔2秒执行1次共执行多次 
- (void)setupSonThreadJJGCDTimerWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{ 

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0); 
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue); 
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC)); 
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC); 
    dispatch_source_set_timer(self.timer, start, interval, 0); 

    __block int count = 0; 
    dispatch_source_set_event_handler(self.timer, ^{ 
        // 执行事件 
        NSLog(@"setupSonThreadJJGCDTimerWithStartTimeSinceNow------------%@", [NSThread currentThread]); 
        count++; 
        if (count == repeatcount) { 
            dispatch_cancel(self.timer); 
            self.timer = nil; 
        } 

    }); 

    dispatch_resume(self.timer); 
} 


 

使用例子,每隔0.01秒重复执行一次

// 0.1 秒执行一次 
- (void)listenSanning 
{ 
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0); 
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue); 
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)); 
    uint64_t interval = (uint64_t)(0.1 * NSEC_PER_SEC); 
    dispatch_source_set_timer(self.timer, start, interval, 0); 
     
    dispatch_source_set_event_handler(self.timer, ^{ 
         
        if ([self.centralManager isScanning]) { 
            NSLog(@"_________________________________ 扫描ing"); 
        } 
    }); 
     
    dispatch_resume(self.timer); 
} 