NSOperationQueue 队列

封装好操作，就是任务后，添加到队列中
只要将任务添加到自己创建的队列中，那么队列内部会自动调用start()方法
只要将任务添加到队列中，就会开启一个新的线程执行队列
非主队列就相当于GCD中的全局队列，非main，就是GCD中的global
除了主队列，其他队列不需要名字

---

非主队列

NSOpertion 可以add到NSOperationQueue里面让Queue来触发其执行,
一旦NSOperation被add到Queue里面那么我们就不care它自身是不是并发设计的了

因为被add到Queue里面的operation必定是并发的.
而且我们可以设置Queue的maxConcurrentOperationCount来指定最大的并发数(也就是几个operation可以同时被执行,
如果这个值设为1, 那这个Queue就是串行队列了).

为嘛添加到Queue里面的operation一定会是并发执行的呢? Queue会为每一个add到队列里面的operation创建一个
线程来运行其start函数, 这样每个start都分布在不同的线程里面来实现operation们的并发执行.

重要的事情再强调一遍: 我们这边所说的并发都是指NSOperation之间的并发(多个operation同时执行)

---

主队列

如果maxConcurrentOperationCount设置为1或者把operation放到[NSOperationQueue mainQueue]里面执行,
那它们只会顺序(Serial)执行, 当然就不可能并发了.

[NSOperationQueue mainQueue] 返回的主队列, 这个队列里面任务都是在主线程执行的
(当然如果你像AFNetworking一样在start函数创建子线程了, 那就不是在主线程执行了),
而且它会忽略一切设置让你的任务顺序的非并发的执行, 所以如果你把NSOperation放到mainQueue里面了,
那你就放弃吧, 不管你怎么折腾, 它是绝对不会并发滴. 当然, 如果是[[NSOperationQueue alloc] init]
那就是子队列(子线程)了.

那...那不对呀, 如果我在子线程调用[operation start]函数, 或者把operation放到非MainQueue里面执行,
但是在operation的内部把start抛到主线程来执行(利用主线程的main run loop), 那多个operation其实不
都是要在主线程执行的么, 这样还能并发? Luckily, 仍然是并发执行的(其实我想说的是那必须能并发啊...哈哈).

---

NSOperationQueue 的串行与并发

默认是并发
如果想在主线程中执行任务，那么直接创建mainQueue即可
如果想实现串行，设置maxConcurrentOperationCount = 0

---

NSOperationQueue 暂停、恢复、取消

暂停队列中的任务；YES需要暂停，NO恢复执行。
暂停任务，如果在任务执行的过程中暂停队列的任务，那么当前正在执行的任务并不会被暂停，而是会暂停队列中的下一个任务
恢复任务，是从队列中第一个没有被执行过的任务开始恢复

取消任务，和暂停任务一样，不会取消当前正在执行的任务；所以在执行耗时操作的时候，
每执行一段代码之后就应该判断一下当前操作是否被取消，可以节约性能，就是免得操作被取消了，
没有及时判断，还回去执行，这样就损耗性能了。

self.queue.suspended = !self.queue.suspended;// 暂停
[self.queue cancelAllOperations];// 取消