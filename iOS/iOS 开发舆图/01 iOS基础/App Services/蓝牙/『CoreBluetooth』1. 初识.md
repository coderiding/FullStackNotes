---
title: 『CoreBluetooth』1. 初识
tags: 蓝牙
categories: 蓝牙
abbrlink: 14221
date: 2016-06-11 12:01:03
---

公司做玩具的，很多地方需要和硬件通信，这个项目用到的是蓝牙，先开一个坑，以后再继续介绍其他的通信方式。

刚开始接触通信真是完全懵逼了好吗…Core Audio，Core Bluetooth 什么的完全不熟好吗…其中还涉及很多 Core Image，Core Video，AVFoundation 真是头大啊。学习曲线陡陡的，压力很大大大大…和硬件沟通的时候，一上来就是音频正弦波什么的，只能在旁边“哦哦哦…”。

因为自己是渣，所以就从渣的角度来谈谈 Core Bluetooth 吧。


环境信息
Mac OS X 10.11.3
iOS 9.2.1
Xcode 7.2.1
Bluetooth 4.0



正文

因为是按照 API 的流程来学习的，所以还是按照 API 的顺序来写吧。文档链接：



<!-- more -->



当然，2013年的 WWDC 也讲到了 Core Bluetooth，更早期虽然也讲到了，但是并不建议去学习 API，因为 iOS9 真是弃用了一堆方法啊。WWDC 视频地址：

> https://developer.apple.com/videos/play/wwdc2013/703/

在看完整个官方文档之后，受益匪浅，这个系列的其他文章列表：

> [CoreBluetooth2 作为 Central 时的数据读写](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role.html)
> [CoreBluetooth3 作为 Central 时的数据读写（补充）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)
> [CoreBluetooth4 作为 Central 时的数据读写（最佳实践）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)
> [CoreBluetooth5 作为 Central 时的数据读写（OTA 固件升级与文件传输）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-ota.html)
> [CoreBluetooth6 作为 Peripheral 时的请求响应](http://www.saitjr.com/ios/core-bluetooth-response-as-peripheral.html)
> [CoreBluetooth7 作为 Peripheral 时的请求响应（最佳实践）](http://www.saitjr.com/ios/core-bluetooth-response-as-peripheral-best-practices.html)
> [CoreBluetooth8 后台运行蓝牙服务](http://www.saitjr.com/ios/【ios】corebluetooth8-后台运行蓝牙服务.html)

## Overview

随着可穿戴设备的普及，蓝牙通信也用得越来越多了。常常谈到的 BLE 技术则是 Bluetooth Low Energy 的简称（见名知意…

## central 与 peripheral

蓝牙通信中，首先需要提到的就是 central 和 peripheral 两个概念。这是设备在通信过程中扮演的两种角色。直译过来就是 [中心] 和 [周边(可以理解为外设)] 。iOS 设备既可以作为 central，也可以作为 peripheral，这主要取决于通信需求。官方 API 上举的例子能很容易的帮助我们理解这两个角色。

在和心率监测仪通信的过程中，监测仪作为 peripheral，iOS 设备作为 central。区分的方式即是这两个角色的重要特点：提供数据的是谁，谁就是 peripheral；需要数据的是谁，谁就是 central。就像是 client 和 server 之间的关系一样。

![Xnip2020-11-06_09-11-52](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-11-52.jpg)

## 那怎么发现 peripheral 呢？

在 BLE 中，最常见的就是广播。实际上，peripheral 在不停的发送广播，希望被 central 找到。广播的信息中包含它的名字等信息。如果是一个温度调节器，那么广播的信息应该还会包含当前温度什么的。

那么 central 的作用则是去 scan，找到需要连接的 peripheral，连接后便可进行通信了。

## peripheral 数据构成

虽然是说通信，但是苹果还是很贴心的先讲解了 peripheral 的基本构成。因为后面很多的用法都涉及到这个构成，毕竟苹果的命名规范就是以长著称的不是吗。所以，如果了解了构成，那后面的类名真是很容易明白（这也是我不翻译关键词的原因）。

一个 peripheral 包含一个或多个 service ，或提供关于信号强度的信息。service 是数据和相关行为的集合。例如，一个心率监测仪的数据就可能是心率数据。

service 本身又是由 characteristic 或者其他 service 组成的。characteristic 又提供了更为详细的 service 信息。还是以心率监测仪为例，service 可能会包含两个 characteristic，一个描述当前心率带的位置，一个描述当前心率的数据。

![Xnip2020-11-06_09-12-25](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-12-25.jpg)

## 相关类

当 central 成功连上 peripheral 后，它便可以获取 peripheral 提供的所有 service 和 characteristic。通过对 characteristic 的数据进行读写，便可以实现 central 和 peripheral 的通信。

#### 设备作为 central 时

当 central 和作为外设的 peripheral 通信时，绝大部分操作都在 central 这边。此时，central 被描述为`CBCentralManager`，这个类提供了扫描、寻找、连接 peripheral （被描述为`CBPeripheral`）的方法。

下图标示了 central 和 peripheral 在 Core Bluetooth 中的表示方式：

![Xnip2020-11-06_09-23-21](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-23-21.jpg)

当你操作 peripheral 的时候，实际上是在和它的 service 和 characteristic 打交道，这两个分别由`CBService`和`CBCharacteristic`表示。

一个 peripheral 包含多个 service，而一个 service 又可以包含多个 characteristic，所以他们的关系大致可以表示为：

![Xnip2020-11-06_09-23-37](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-23-37.jpg)

#### 设备作为 Peripheral 时

在 OS X 10.9 和 iOS 6 以后，设备除了能作为 central 外，还可以作为 peripheral。也就是说，可以发起数据，而不像以前只能管理数据了。

那么在此时，它被描述为`CBPeripheralManager`，既然是作为 peripheral，那么这个类提供的主要方法则是对 service 的管理，同时还兼备着向 central 广播数据的功能。peripheral 同样会对 central 的读写要求做出相应。

下图则是设备作为 central 和 Peripheral 的示意图：

![Xnip2020-11-06_09-25-33](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-25-33.jpg)

在充当 peripheral 时，`CBPeripheralManager`处理的是可变的 service 和 characteristic，分别由`CBMutableService`和`CBMutableCharacteristic`表示。

下图则是在设备 peripheral 时，相关类的关系：

![Xnip2020-11-06_09-25-59](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-25-59.jpg)

之后还会讲到更多的关于 central 和 peripheral 的细节。