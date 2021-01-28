DEMO:https://github.com/awliu/demo_dispatch_group

dispatch_group 基本语法 
dispatch_group_t group =  dispatch_group_create(); 

dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
      // 执行第一个1个耗时的异步操作 
  }); 

dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
      // 执行第二个2个耗时的异步操作 
  }); 

dispatch_group_notify(group, dispatch_get_main_queue(), ^{ 
      // 等前面的异步操作都执行完毕后，回到主线程... 
  }); 
  
  
   
  
  
  
dispatch_group 使用场景

如果有这么1种需求,首先：分别异步执行2个耗时的操作,其次：等2个异步操作都执行完毕后，再回到主线程执行操作；
如果想要快速高效地实现上述需求，可以考虑用队列组；
例子：合成图片：等待图片1和图片2都下载完后，就执行最后的合成图片操作；
步骤是：a、下载图片1；b、下载图片2；c、合成图片
例子 
/* 
  * 1 pic1 和pic2下载完后，才去合成pic1和pic2，最后更新UI 
  * 2 pic1 和pic2下载，合成pic1和pic2，都在子线程 
  * 3 更新UI，在主线程 
  */ 
- (void)dispatchGroup{ 

    // son thread 
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
    // creat group 
    dispatch_group_t group = dispatch_group_create(); 

    // download pic1 in son thread 
    dispatch_group_async(group, queue, ^{ 
        [NSThread sleepForTimeInterval:5]; 
        NSLog(@"download pic1 finish in thread %@",[NSThread currentThread]); 
    }); 

    // download pic2 int son thread 
    dispatch_group_async(group, queue, ^{ 
        [NSThread sleepForTimeInterval:5]; 
        NSLog(@"download pic2 finish in thread %@",[NSThread currentThread]); 
    }); 

    // bind pic1 and pic2 and reload UI 
    dispatch_group_notify(group, queue, ^{ 
        [NSThread sleepForTimeInterval:5]; 
        NSLog(@"bind pic1 and pic2 finish in thread %@",[NSThread currentThread]); 

        // reload UI in main thread 
        dispatch_async(dispatch_get_main_queue(), ^{ 
            NSLog(@"reload UI finish in thread %@",[NSThread currentThread]); 
        }); 
    }); 

} 