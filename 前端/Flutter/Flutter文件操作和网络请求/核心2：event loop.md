![esKOm3](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/esKOm3.png)

### 执行流程

- （1）运行App并执行main方法。
- （2）开始并优先处理microtask queue，直到队列里为空。
- （3）当microtask queue为空后，开始处理event queue。如果event queue里面有event，则执行，每执行一条再判断此时新的microtask queue是否为空，并且每一次只取出一个来执行。可以”“这样理解，在处理所有event之前我们会做一些事情，并且会把这些事情放在microtask queue中。
- （4）microtask queue和event queue都为空，则App可以正常退出。”

### 注意事项：
当处理microtask queue时，event queue是会被阻塞的。所以microtask queue中应避免任务太多或长时间处理，否则将导致App的绘制和交互等行为被卡住。所以，绘制和交互等应该作为event存放在event queue中，这样更合适。”
