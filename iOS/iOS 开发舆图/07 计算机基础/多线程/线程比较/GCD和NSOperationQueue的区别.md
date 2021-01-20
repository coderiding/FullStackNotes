- GCD是纯c语言的api，NSOperationQueue是基于gcd的封装。
- GCD只支持FIFO先进先出，NSOperationQueue可以调整执行顺序和设置最大并发量。
- NSOperation可以轻松在Operation间设置依赖，gcd实现比较麻烦。
- NSOperation支持kvo，可以监测Operation是否正在执行（isExecuted），是否结束（isFinished）,是否取消（isCanceld）。
- GCD的执行速度比NSOperationQueue快。
- GCD任务之间不太相互依赖。

多线程NSOPeration介绍：vs GCD

- NSOPerationQueue 队列相当于GCD的线程
- GCD 的子线程（全局线程）就是NSOPerationQueue的子队列
- GCD 的主线程就是NSOPerationQueue的主队列

---

NSOperation 特有：

- maxConcurrentOperationCount 有最大并发数限制(也就是几个operation可以同时被执行,如果这个值设为1, 那这个Queue就是串行队列了)
- NSOperation 的并发都是指NSOperation之间的并发(多个operation同时执行)
- NSOperation 的主队列（也叫主线程）时，可以是maxConcurrentOperationCount设置为1或者把operation放到[NSOperationQueue mainQueue]里面执行, 那它们只会顺序(Serial)执行, 当然就不可能并发了
- NSOperation 的子队列（也叫子线程）时，可以是[[NSOperationQueue alloc] init]那就是子队列(子线程)
如果想实现串行，设置maxConcurrentOperationCount = 0