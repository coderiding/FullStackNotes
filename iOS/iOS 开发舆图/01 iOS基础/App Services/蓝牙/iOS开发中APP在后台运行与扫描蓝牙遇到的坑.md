---
title: iOS开发中APP在后台运行与扫描蓝牙遇到的坑
tags:
  - 蓝牙
  - 后台运行
categories: 蓝牙
abbrlink: 3418
date: 2016-06-18 12:01:03
---

### 后台长久任务：

- 打开后台模式中的使用蓝牙功能(手机为中心模式)：TARGET→Capabilities→Background Modes→Uses Bluetooth LE accessories(勾选)
- 在AppDelegate.m中添加下面代码：

```
#pragma mark APP进入后台触发的方法
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 进入后台，处理后台任务
    [self comeToBackgroundMode];
}

#pragma mark 处理后台任务
- (void)comeToBackgroundMode {
    self.count = 0;
    // 初始化一个后台任务BackgroundTask，这个后台任务的作用就是告诉系统当前App在后台有任务处理，需要时间
    [self beginBackgroundTask];

}

#pragma mark 开启一个后台任务
- (void)beginBackgroundTask {
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{

    }];
    // 开启定时器，不断向系统请求后台任务执行的时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];

}

#pragma mark 结束一个后台任务
- (void)endBackgroundTask {
    UIApplication *app = [UIApplication sharedApplication];
    [app endBackgroundTask:self.bgTask];
    self.bgTask = UIBackgroundTaskInvalid;
    // 结束计时
    [self.timer invalidate];
}

#pragma mark 申请后台运行时间
- (void)applyForMoreTime {
    self.count ++;
    NSLog(@"%ld，剩余时间：%f", (long)self.count, [UIApplication sharedApplication].backgroundTimeRemaining);

    if (self.count % 150 == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 结束当前后台任务
            [self endBackgroundTask];
            // 开启一个新的后台任务
            [self beginBackgroundTask];
        });
    }

}

#pragma mark APP进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 结束后台任务
    [self endBackgroundTask];
}12345678910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455
```

- 说明：这种方法会执行后台任务，但是最多在后台运行3分钟。

<!-- more -->

### APP在后台扫描蓝牙(两种方式)

- 第一种方式：扫描所有蓝牙设备

```
// self.cbCentralMgr 为蓝牙中心模块
[self.cbCentralMgr scanForPeripheralsWithServices:nil options:nil];12
```

- 第二种方式：扫描指定serviceUUID蓝牙设备

```
[self.cbCentralMgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"指定的serviceUUID"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];1
```

### 遇到的坑

- **坑一：**由于苹果的限制，使用第一种方式扫描，APP在后台运行时是扫描不到任何信息的；如果想在后台扫描蓝牙设备，必须使用第二种方式；
- **坑二：**使用第二种方式需要注意，如果设置CBCentralManagerScanOptionAllowDuplicatesKey的值为NO，在后台调用扫描时只能，扫描到一次，即使蓝牙广播的数据有变化，也不会接收到新的广播
- **坑三：**使用第二种方式，即使CBCentralManagerScanOptionAllowDuplicatesKey如果设置为YES，会持续接收到蓝牙发出的广播，但是接收到的蓝牙广播的内容是不会变的；(这里苹果是不推荐我们设置为YES，因为这对手机的电量消耗等是有影响的，但是在某些特定的场景下我们是必须这样做的)
- **坑四：**即使我们使用第二种方式扫描，也设置了CBCentralManagerScanOptionAllowDuplicatesKey为YES，但是如果超过三分钟扫描不到任何蓝牙设备，后台任务一样会停止。

### 建议

由于苹果的这种特性，建议在前台时扫描蓝牙设备时，设置CBCentralManagerScanOptionAllowDuplicatesKey为NO；在后台扫描蓝牙时，设置CBCentralManagerScanOptionAllowDuplicatesKey为YES