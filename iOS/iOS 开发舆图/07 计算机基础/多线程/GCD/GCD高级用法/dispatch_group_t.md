```

//队列组
-(void)demo4{
    NSLog(@"begin");
    //创建队列组
    dispatch_group_t group =dispatch_group_create();
    
    //开启异步任务
    dispatch_group_async(group,dispatch_get_global_queue(0,0), ^{
        //模拟网络卡
        [NSThreadsleepForTimeInterval:arc4random_uniform(5)];//休眠5秒内随机时间
        NSLog(@"%@下载 L01.zip",[NSThreadcurrentThread]);
    });
    
    dispatch_group_async(group,dispatch_get_global_queue(0,0), ^{
        //模拟网络卡
        [NSThreadsleepForTimeInterval:arc4random_uniform(5)];//休眠5秒内随机时间
        NSLog(@"%@下载 L02.zip",[NSThreadcurrentThread]);
    });

    dispatch_group_notify(group,dispatch_get_global_queue(0,0), ^{
        NSLog(@"%@下载完成",[NSThreadcurrentThread]);
    });
}

```