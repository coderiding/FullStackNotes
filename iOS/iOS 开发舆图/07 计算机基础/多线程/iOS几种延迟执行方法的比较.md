---
title: iOS几种延迟执行方法的比较
tags: 延迟
categories: 技术改变世界
abbrlink: 41409
date: 2017-04-08 20:25:08
---

项目开发中经常会用到方法的延时调用，具体的调用场景不做赘述，下面列举现有的几种实现方式：

* 1.performSelector
* 2.NSTimer
* 3.sleep
* 4.GCD

延迟执行方法：

```
- (void)delayMethods{
		NSLog(@"方法被延迟执行");
}
```

------

### 方法一：performSelector

```[self performSelector:@selector(delayMethods) withObject:nil afterDelay:1.0];```

分析：该方法是一种非阻塞执行方式，不会影响其他进程；必须在主线程中执行；

可以主动取消操作：

```[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethods) object:nil];```

如果要取消当前所有延时操作：

```[NSObject cancelPreviousPerformRequestsWithTarget:self];```

注：该方法不够安全，这个方法在调用时会设置当前runloop中的timer。但是我们知道：只有主线程会在创建的时候默认自动运行一个runloop，并含有timer，普通的子线程是没有runloop和timer的。所以在子线程中被调用的时候，我们的代码中延时操作的代码就会一直等待timer得调度，但是实际上子线程中没有timer，这就会导致我们的延时操作代码永远都不会被执行。



<!-- more -->

### 方法二：NSTimer

```NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delayMethods) userInfo:nil repeats:NO];```

分析：该方法是一种非阻塞执行方式，不会影响其他进程；必须在主线程中执行；默认为在主线程中设置一个定时器；可以设置是否重复执行延时操作；

```取消延时操作：[timer invalidate];```

注：若repeats参数设置为NO，执行完成后timer会自动销毁，如果repeats参数设置为YES，执行完成后，必须手动调用[timer invalidate]才能销毁定时器；

### 方法三：sleep

```[NSThread sleepForTimeInterval:1.0];```

分析：该方法是一种阻塞执行方式，最好放在子线程中执行，否则会影响其他方法的执行。

### 方法四：GCD

```
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 \* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self delayMethods];
});
```

分析：该方法是一种非阻塞执行方式，不会影响其他进程；可以在参数中设置执行的进程：

```
dispatch_queue_t queen = dispatch_get_global_queue(0, 0);

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), queen, ^{
		[self delayMethods];
});
```

也可以设置是否重复执行：

```
__weak typeof(self) ws = self;
dispatch_queue_t queen = dispatch_get_global_queue(0, 0);
dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queen);

if (timer) {
		dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 1.0 * NSEC_PER_SEC);
 		dispatch_source_set_event_handler(timer, ^{
				[ws delayMethods];
		});

		dispatch_resume(timer);
}
```
注：因为该方法交给了GCD自动处理，因此不容易取消操作。