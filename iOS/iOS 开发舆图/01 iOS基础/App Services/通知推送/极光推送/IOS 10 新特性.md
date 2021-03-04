https://community.jiguang.cn/article/464837

备用链接
https://app.yinxiang.com/shard/s35/nl/9757212/c426ba87-fa33-4c52-b4bd-1f6ea426bcae

### 为什么是［通知］而不是［推送］
先来看一下iOS10通知相关的第一个更新点就是新加了一个框架User Notification Framework，从字面翻译来看应该翻译成“用户通知框架”，而通常大家所了解的“推送”翻译成英文应该是“Push”，“Push”其实只是［通知］触发的一种方式，而［通知］其实是操作系统层面的一种UI展示。

在苹果的官方文档中Notification分为两类：

Remote（远程，也就是之前所说的Push的方式）

Local（本地，通知由本地的事件触发，iOS10中有三种不同的触发‘Trigger’方式，稍后会进行详细说明）

所以，［推送］只是［通知］的一种触发方式，而从iOS迭代更新的历史特征中看，［通知］应该是是被苹果作为一个重点内容来延展的。（从最初的单纯展示和简单回调，到Backgroud的支持，再后来整体的Payload的长度由256字节扩展到2K再到4K，再看这次的独立框架还有丰富的特性更新）