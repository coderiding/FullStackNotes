---
title: 『CoreBluetooth』5. 作为 Central 时的数据读写（OTA 固件升级与文件传输）
tags: 蓝牙
categories: 蓝牙
abbrlink: 21473
date: 2016-06-15 10:24:30
---

占坑文。并未详细介绍 OTA 更新，更多的是大文件传输需要注意的方面。

先期文章：

> [CoreBluetooth1 初识](http://www.saitjr.com/ios/core-bluetooth-overview.html)

[CoreBluetooth2 作为 Central 时的数据读写](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role.html)

[CoreBluetooth3 作为 Central 时的数据读写（补充）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)

[CoreBluetooth4 作为 Central 时的数据读写（最佳实践）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)

代码可参考：

> https://github.com/saitjr/STBLETool.git

因为手上的硬件都被我在之前开发时刷到了最新版本，所以本文对固件升级的讲解并未经过测试。对 OTA 的认识也不是很深入。目前对 OTA 操作（仅限 central 端）仅仅停留在握手与蓝牙文件传输。之后等我有未升级版本硬件的时候，再进行测试，所以本文会持续更新。

既然不确定 OTA 的传输过程，那就按照我的理解来说说文件传输吧。

OTA（Over-the-Air）空中传输，一般用于固件升级，网上的资料大多是怎么给手机系统升级，少部分资料是 peripheral 怎么接收并进行升级，唯独没有 central 端怎么传输的。其实文件传输很简单，只是蓝牙传输的数据大小使得这一步骤稍显复杂。

首先，文件传输，其实也是传输的数据，即 `NSData`，和普通的 peripheral 写入没什么区别。固件升级的文件一般是 `.bin` 文件，也有 `.zip` 的。不过这些文件，都是数据，所以首先将文件转为 `NSData`。

但是 data 一般很长，毕竟是文件。直接通过 `writeValue:forCharacteristic:type:` 写入的话，不会有任何回调。哪怕是错误的回调，都没有。这是因为蓝牙单次传输的数据大小是有限制的。

具体的大小我不太明确，看到 StackOverflow 上有人给出的 20 bytes，我就直接用了，并没有去具体查证（不过试了试 30 bytes，回调数据长度错误）。既然长度是 20，那在每次发送成功的回调中，再进行发送就好，直到发送完成。

下面来讨论下我是怎么做的吧，也希望有更好方案的朋友评论下。



<!-- more -->

## 区别普通写入与文件写入

因为 OTA 的写入可能需要做进度条之类的，所以最好和普通的写入回调区分开。

分割数据并发送

每次都要记录上一次已经写入长度（偏移量 `self.otaSubDataOffset`），然后截取 20 个长度。需要注意的是最后一次的长度，注意不要越界了。

数据的发送和普通写入没什么区别。

## 当前已发送长度与发送结束的回调

在每次写入成功中，判断是否已经发送完成（已发送的长度和总长度相比）。如果还未发送完成，则返回已发送的长度给控制器（可以通过代理实现）。如果已发送完成，则返回发送完成（可以通过代理实现）。

详细的代码可以参考：

> https://github.com/saitjr/STBLETool.git