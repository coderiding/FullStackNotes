```objectivec
// NSOperation 依赖同一个任务

- (void)setupNSOperationDependanceSame  
{  
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@" 任务一：下载图片 - %@", [NSThread currentThread]);  
        [NSThread sleepForTimeInterval:1.0];  
    }];  

    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@" 任务二：打水印   - %@", [NSThread currentThread]);  
        [NSThread sleepForTimeInterval:1.0];  
    }];  

    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@" 任务三：上传图片 - %@", [NSThread currentThread]);  
        [NSThread sleepForTimeInterval:1.0];  
    }];  

    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{  
        NSLog(@" 任务四：我在谁后面呢？？ - %@", [NSThread currentThread]);  
        [NSThread sleepForTimeInterval:1.0];  
    }];  

    [operation2 addDependency:operation1];  
    [operation3 addDependency:operation2];  
    [operation4 addDependency:operation2];  

    // 添加任务到队列  
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];  
    [queue addOperations:@[operation3, operation2, operation1,operation4] waitUntilFinished:NO];  
}  

----------------------SWIFT

    operationQueue.maxConcurrentOperationCount = 4 
    self.activityIndicator.startAnimating() 
     
    guard let url = URL(string: "https://placebeard.it/355/140") else {return } 
    let op1 = convenienceOperation(setImageView: imageView1, withURL: url) 
    let op2 = convenienceOperation(setImageView: imageView2, withURL: url) 
    op2.addDependency(op1) 
    let op3 = convenienceOperation(setImageView: imageView3, withURL: url) 
    op3.addDependency(op2) 
    let op4 = convenienceOperation(setImageView: imageView4, withURL: url) 
    op4.addDependency(op3) 
     
     
     
    DispatchQueue.global().async { 
        [weak self] in 
        self?.operationQueue.addOperations([op1,op2,op3,op4], waitUntilFinished: true) 
        DispatchQueue.main.async { 
            self?.activityIndicator.stopAnimating() 
        } 
    } 

多线程NSOperation应用场景【任务 依赖上一个任务】NSBlockOperation

例子1： 

// NSOperation 依赖上一个任务 
- (void)setupNSOperationDependance 
{ 
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务一：下载图片 - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务二：打水印  - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务三：上传图片 - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    [operation2 addDependency:operation1]; 
    [operation3 addDependency:operation2]; 

     // 添加任务进队列 
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; 
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO]; 
} 

例子2：

  NSOperationQueue*queue = [[NSOperationQueue alloc]init]; 

  // 下第一张图片 
  NSOperation*op1 = [NSBlockOperation blockOperationWithBlock:^{ 
      NSLog(@" 下载1"); 
  }]; 

  // 下第二张图片 
  NSOperation*op2 = [NSBlockOperation blockOperationWithBlock:^{ 
      NSLog(@" 下载2"); 
  }]; 

  NSOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{ 
      NSLog(@" 下载3"); 

      // 回主线程渲染图片 
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{ 
          NSLog(@" 渲染"); 
      }]; 
  }]; 

  // 监听任务是否执行完毕 
  op1.completionBlock = ^(){ 
      NSLog(@" 图片1下载完毕"); 
  }; 
  op2.completionBlock = ^(){ 
      NSLog(@" 图片2下载完毕"); 
  }; 

// 添加依赖 
// 只要添加了依赖，那么就会等到依赖的任务执行完毕，才会执行当前任务 
//1 、添加依赖，不能添加循环依赖 
//2 、NSOperation可以跨队列添加依赖 
[op2 addDependency:op1];// 操作op2依赖op1，就是op1完成后，才能到op2；下面的以此类推 
[op3 addDependency:op2]; 

// 把操作加入队列 
[queue addOperation:op1]; 
[queue addOperation:op2]; 
[queue addOperation:op3]; 

多线程NSOperation应用场景【任务 依赖同一个任务】NSBlockOperation
// NSOperation 依赖同一个任务 
- (void)setupNSOperationDependanceSame 
{ 
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务一：下载图片 - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务二：打水印  - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务三：上传图片 - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{ 
        NSLog(@" 任务四：我在谁后面呢？？ - %@", [NSThread currentThread]); 
        [NSThread sleepForTimeInterval:1.0]; 
    }]; 

    [operation2 addDependency:operation1]; 
    [operation3 addDependency:operation2]; 
    [operation4 addDependency:operation2]; 

     // 添加任务到队列 
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; 
    [queue addOperations:@[operation3, operation2, operation1,operation4] waitUntilFinished:NO]; 
}
```