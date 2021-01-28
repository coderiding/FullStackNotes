方法1：使用dispatch_get_main_queue

dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
       // 执行耗时的异步操作...CODE 
        NSLog(@" 处理子线程工作"); 
        [NSThread sleepForTimeInterval:2]; 

       dispatch_async(dispatch_get_main_queue(), ^{ 
          // 回到主线程，执行UI刷新操作 
          NSLog(@" 处理主线程工作"); 
       }); 

}); 

// 主线程 
dispatch_async(dispatch_get_main_queue(), ^{ 

}); 

// 子线程 
dispatch_async(dispatch_get_global_queue(0, 0), ^{ 

}); 


 

-------------------------------------------
方法2：使用performSelectorOnMainThread

// 子线程切换到主线程:使用performSelectorOnMainThread（swift中不能用这个方法） 
- (void)changeThreadWithPerform 
{ 
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
        // 执行耗时的异步操作...CODE 
        NSLog(@" 处理子线程工作"); 
        [NSThread sleepForTimeInterval:2]; 

        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:NO]; 

    }); 
} 

- (void)mainThread 
{ 
    // 回到主线程，执行UI刷新操作 
    NSLog(@" 处理主线程工作"); 
} 