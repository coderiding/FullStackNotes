卡顿监控方案：runloop

要想监听 RunLoop，你就首先需要创建一个 CFRunLoopObserverContext 观察者，代码如下：

```
CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities,YES,0,&runLoopObserverCallBack,&context);
```

将创建好的观察者 runLoopObserver 添加到主线程 RunLoop 的 common 模式下观察。然后，创建一个持续的子线程专门用来监控主线程的 RunLoop 状态。

**汶：监控卡顿核心的思路：一旦发现进入睡眠前的 kCFRunLoopBeforeSources 状态，或者唤醒后的状态 kCFRunLoopAfterWaiting，在设置的时间阈值内（这个时间阈值就是你自己认为多长时间内没反应就认为是卡顿的时间）一直没有变化，即可判定为卡顿**。接下来，我们就可以 dump 出堆栈的信息，从而进一步分析出具体是哪个方法的执行时间过长。

开启一个子线程监控的代码如下：

```
// 创建子线程监控
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    // 子线程开启一个持续的 loop 用来进行监控
    while (YES) {
        // 汶：代码中的 NSEC_PER_SEC，代表的是触发卡顿的时间阈值
        long semaphoreWait = dispatch_semaphore_wait(dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));
        if (semaphoreWait != 0) {
            if (!runLoopObserver) {
                timeoutCount = 0;
                dispatchSemaphore = 0;
                runLoopActivity = 0;
                return;
            }
            //BeforeSources 和 AfterWaiting 这两个状态能够检测到是否卡顿
            if (runLoopActivity == kCFRunLoopBeforeSources || runLoopActivity == kCFRunLoopAfterWaiting) {
                // 将堆栈信息上报服务器的代码放到这里
                // 汶：上报的堆栈信息，就可以找到具体的类和方法，从而找到出问题卡顿的方法

            } //end activity
        }// end semaphore wait
        timeoutCount = 0;
    }// end while
});
```

代码中的 NSEC_PER_SEC，代表的是触发卡顿的时间阈值，单位是秒。可以看到，我们把这个阈值设置成了 3 秒。那么，这个 3 秒的阈值是从何而来呢？这样设置合理吗？

其实，触发卡顿的时间阈值，我们可以根据 WatchDog 机制来设置。WatchDog 在不同状态下设置的不同时间，如下所示：

启动（Launch）：20s；
恢复（Resume）：10s；
挂起（Suspend）：10s；
退出（Quit）：6s；
后台（Background）：3min（在 iOS 7 之前，每次申请 10min； 之后改为每次申请 3min，可连续申请，最多申请到 10min）。

通过 WatchDog 设置的时间，我认为可以把启动的阈值设置为 10 秒，其他状态则都默认设置为 3 秒。总的原则就是，要小于 WatchDog 的限制时间。当然了，这个阈值也不用小得太多，**原则就是要优先解决用户感知最明显的体验问题。**

如何获取卡顿的方法堆栈信息？
子线程监控发现卡顿后，还需要记录当前出现卡顿的方法堆栈信息，并适时推送到服务端供开发者分析，从而解决卡顿问题。那么，在这个过程中，如何获取卡顿的方法堆栈信息呢？

获取堆栈信息的一种方法是**直接调用系统函数**。这种方法的优点在于，性能消耗小。但是，它只能够获取简单的信息，也没有办法配合 dSYM 来获取具体是哪行代码出了问题，而且能够获取的信息类型也有限。**这种方法，因为性能比较好，所以适用于观察大盘统计卡顿情况**，而不是想要找到卡顿原因的场景。

直接调用系统函数方法的主要思路是：用 signal 进行错误信息的获取。具体代码如下：

```
static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
};
 
static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);
 
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *exceptionArray = [exception callStackSymbols]; // 得到当前调用栈信息
    NSString *exceptionReason = [exception reason];       // 非常重要，就是崩溃的原因
    NSString *exceptionName = [exception name];           // 异常类型
}
 
void SignalHandler(int code)
{
    NSLog(@"signal handler = %d",code);
}
 
void InitCrashReport()
{
    // 系统错误信号捕获
    for (int i = 0; i < s_fatal_signal_num; ++i) {
        signal(s_fatal_signals[i], SignalHandler);
    }
    
    //oc 未捕获异常的捕获
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}
 
int main(int argc, char * argv[]) {
    @autoreleasepool {
        InitCrashReport();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));

```

另一种方法是，直接用 PLCrashReporter这个开源的第三方库(**汶：使用第三方库配合获取出现卡顿的堆栈信息**)https://opensource.plausible.coop/src/projects/PLCR/repos/plcrashreporter/browse来获取堆栈信息。这种方法的特点是，能够定位到问题代码的具体位置，而且性能消耗也不大。所以，也是我推荐的获取堆栈信息的方法。

具体如何使用 PLCrashReporter 来获取堆栈信息，代码如下所示：

```
// 获取数据
NSData *lagData = [[[PLCrashReporter alloc]
                                          initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
// 转换成 PLCrashReport 对象
PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
// 进行字符串格式化处理
NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
// 将字符串上传服务器
NSLog(@"lag happen, detail below: \n %@",lagReportString);
```

搜集到卡顿的方法堆栈信息以后，就是由开发者来分析并解决卡顿问题了。

在今天这篇文章中，我们用到的从监控卡顿到收集卡顿问题信息的完整代码，你都可以点击这个链接查看。https://github.com/ming1016/DecoupleDemo/blob/master/DecoupleDemo/SMLagMonitor.m