卡顿分析：runloop原理
（汶：卡顿，就是是针对用户操作的时候说的，用户在界面上滑动，或者点击时，出现的卡顿，就是指这里的卡顿）

RunLoop 原理
对于 iOS 开发来说，监控卡顿就是要去找到主线程上都做了哪些事儿。我们都知道，线程的消息事件是依赖于 NSRunLoop 的（**汶：有线程才会有runloop的存在，runloop会对端口事件等进行处理，所有要做的事，都必须经过runloop**），所以从 NSRunLoop 入手，就可以知道主线程上都调用了哪些方法。我们通过监听 NSRunLoop 的状态，就能够发现调用方法是否执行时间过长，从而判断出是否会出现卡顿。

所以，我推荐的监控卡顿的方案是：通过监控 RunLoop 的状态来判断是否会出现卡顿。（**汶：监控卡顿的思路就是，监控你当前正在做什么事，如果发现你当前做的事卡顿，就能快速解决，而要监控你当前做的事，就要通过监控runloop正在做什么**）

RunLoop 是 iOS 开发中的一个基础概念，为了帮助你理解并用好这个对象，接下来我会先和你介绍一下它可以做哪些事儿，以及它为什么可以做成这些事儿。

RunLoop 这个对象，在 iOS 里由 CFRunLoop 实现。简单来说，RunLoop 是用来监听输入源，进行调度处理的。这里的输入源可以是输入设备、网络、周期性或者延迟时间、异步回调。**RunLoop 会接收两种类型的输入源：**一种是来自另一个线程或者来自不同应用的异步消息；另一种是来自预订时间或者重复间隔的同步事件。

**(汶：一个线程只会有一个runloop与之对应)**
RunLoop 的目的是，当有事件要去处理时保持线程忙，当没有事件要处理时让线程进入休眠。所以，了解 RunLoop 原理不光能够运用到监控卡顿上，还可以提高用户的交互体验。通过将那些繁重而不紧急会大量占用 CPU 的任务（比如图片加载），放到空闲的 RunLoop 模式里执行，就可以避开在 UITrackingRunLoopMode 这个 RunLoop 模式时是执行。UITrackingRunLoopMode 是用户进行滚动操作时会切换到的 RunLoop 模式，避免在这个 RunLoop 模式执行繁重的 CPU 任务，就能避免影响用户交互操作上体验。

接下来，我就通过 CFRunLoop 的源码来跟你分享下 RunLoop 的原理吧。

* 第一步:通知 observers：RunLoop 要开始进入 loop 了。紧接着就进入 loop。代码如下：

```
// 通知 observers
if (currentMode->_observerMask & kCFRunLoopEntry ) 
    __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
// 进入 loop
result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);

```

* 第二步:开启一个 do while 来保活线程。通知 Observers：RunLoop 会触发 Timer 回调、Source0 回调，接着执行加入的 block。代码如下：

```
// 通知 Observers RunLoop 会触发 Timer 回调
if (currentMode->_observerMask & kCFRunLoopBeforeTimers)
    __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
// 通知 Observers RunLoop 会触发 Source0 回调
if (currentMode->_observerMask & kCFRunLoopBeforeSources)
    __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
// 执行 block
__CFRunLoopDoBlocks(runloop, currentMode);
接下来，触发 Source0 回调，如果有 Source1 是 ready 状态的话，就会跳转到 handle_msg 去处理消息。代码如下：

if (MACH_PORT_NULL != dispatchPort ) {
    Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
    if (hasMsg) goto handle_msg;
}
```

* 第三步:回调触发后，通知 Observers：RunLoop 的线程将进入休眠（sleep）状态。代码如下：
```
Boolean poll = sourceHandledThisLoop || (0ULL == timeout_context->termTSR);
if (!poll && (currentMode->_observerMask & kCFRunLoopBeforeWaiting)) {
    __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
}
```

* 第四步:进入休眠后，会等待 mach_port 的消息，以再次唤醒。只有在下面四个事件出现时才会被再次唤醒：

基于 port 的 Source 事件；
Timer 时间到；
RunLoop 超时；
被调用者唤醒。
等待唤醒的代码如下：

```
do {
    __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
        // 基于 port 的 Source 事件、调用者唤醒
        if (modeQueuePort != MACH_PORT_NULL && livePort == modeQueuePort) {
            break;
        }
        // Timer 时间到、RunLoop 超时
        if (currentMode->_timerFired) {
            break;
        }
} while (1);
```

* 第五步:唤醒时通知 Observer：RunLoop 的线程刚刚被唤醒了。代码如下：
```
if (!poll && (currentMode->_observerMask & kCFRunLoopAfterWaiting))
    __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
```

* 第六步:RunLoop 被唤醒后就要开始处理消息了：

如果是 Timer 时间到的话，就触发 Timer 的回调；
如果是 dispatch 的话，就执行 block；
如果是 source1 事件的话，就处理这个事件。
消息执行完后，就执行加到 loop 里的 block。代码如下：
```
handle_msg:
// 如果 Timer 时间到，就触发 Timer 回调
if (msg-is-timer) {
    __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
} 
// 如果 dispatch 就执行 block
else if (msg_is_dispatch) {
    __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
} 
 
// Source1 事件的话，就处理这个事件
else {
    CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
    sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
    if (sourceHandledThisLoop) {
        mach_msg(reply, MACH_SEND_MSG, reply);
    }
}
```

* 第七步: 根据当前 RunLoop 的状态来判断是否需要走下一个 loop。当被外部强制停止或 loop 超时时，就不继续下一个 loop 了，否则继续走下一个 loop 。代码如下：
```
if (sourceHandledThisLoop && stopAfterHandle) {
     // 事件已处理完
    retVal = kCFRunLoopRunHandledSource;
} else if (timeout) {
    // 超时
    retVal = kCFRunLoopRunTimedOut;
} else if (__CFRunLoopIsStopped(runloop)) {
    // 外部调用者强制停止
    retVal = kCFRunLoopRunStopped;
} else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
    // mode 为空，RunLoop 结束
    retVal = kCFRunLoopRunFinished;
}
```

* 整个 RunLoop 过程，我们可以总结为如下所示的一张图片。
* 这里只列出了 CFRunLoop 的关键代码，你可以点击这个链接查看完整代码。

* loop 的六个状态
* 通过对 RunLoop 原理的分析，我们可以看出在整个过程中，loop 的状态包括 6 个，其代码定义如下：

```
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry , // 进入 loop
    kCFRunLoopBeforeTimers , // 触发 Timer 回调
    kCFRunLoopBeforeSources , // 触发 Source0 回调
    kCFRunLoopBeforeWaiting , // 等待 mach_port 消息
    kCFRunLoopAfterWaiting ), // 接收 mach_port 消息
    kCFRunLoopExit , // 退出 loop
    kCFRunLoopAllActivities  // loop 所有状态改变
}
```

如果 RunLoop 的线程，进入睡眠前方法的执行时间过长而导致无法进入睡眠，或者线程唤醒后接收消息时间过长而无法进入下一步的话，就可以认为是线程受阻了。如果这个线程是主线程的话，表现出来的就是出现了卡顿。

所以，如果我们要利用 RunLoop 原理来监控卡顿的话，就是要关注这两个阶段。RunLoop 在进入睡眠之前和唤醒后的两个 loop 状态定义的值，分别是 kCFRunLoopBeforeSources 和 kCFRunLoopAfterWaiting ，也就是要触发 Source0 回调和接收 mach_port 消息两个状态。

接下来，我们就一起分析一下，如何对 loop 的这两个状态进行监听，以及监控的时间值如何设置才合理。