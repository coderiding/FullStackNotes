---
title: 苹果通知中心服务ANCS协议分析二
tags: 蓝牙
categories: 蓝牙
abbrlink: 18118
date: 2016-06-12 12:01:03
---

相关文章：
 *[苹果通知中心服务ANCS协议分析](https://www.jianshu.com/p/2ddf76ab85b0)*
 *[低功耗蓝牙BLE介绍](https://www.jianshu.com/p/9ab3efe6147d)*

IOS设备的ANCS服务是为了周边设备通过低功耗蓝牙获取实时通知而产生的机制，它实际上是ble gatt协议的一种封装。

### 区分GAP和GATT中定义的角色的不同

1. 首先GAP中定义了两种角色，一种是中心设备，主要以ios设备为主；二是周边设备，以小型的低功耗设备为主，比如iwatch、各种手环等，他主要是从连接的层面下的定义，即中心设备可以同时连接不同的周边设备，而一个周边设备只能连接一个中心设备。
2. 而对于GATT来说，他是基于c/s模型的，因此它又一个server和client的区分，保持有service和characteristic的为server，而连接上server去读写这些characteristic的为client。

不能想当然的认为中心设备等同于server,周边设备等同于client，他们是不同层面的东西。以两个不同的生活场景进行举例说明：

- 手环中的传感器获取人的运动状态以及身体数据，ios设备从手环中获取这些基础的数据来进行进一步的处理和分析。这个场景中手环是提供数据者，ios设备从中获取设备，因为此时，ios是client，手环是server。
- iwatch等智能手表，可以同步ios设备的短信和来电等，此时数据的提供者是ios设备，而智能手表则作为数据获取者，此时ios是server，而智能周边设备则是client.

<!-- more -->

### 发现和绑定ios设备

如果有了ANCS的基本的知识,我们知道ANCS其实是基于ble gatt协议的，而ANCS扮演的就是gatt协议中的gatt server中的一个service，我们想要获取该service中的内容的话需要gatt client先扫描到该设备，然后连接上gatt server就可以读写其中的service和characteristic来获得信息。

但是根据官方提供的ble gatt client的api实现简单的应用的话，发现能够扫描到很多的ble设备,但是始终无法扫描到ANCS这个服务，这是什么原因呢？莫非ios设备没有打开该服务？
 其实并不是这样的，只要ios设备的蓝牙打开后，ANCS就会不停的发送广播告之周围的gatt client。

那么既然ANCS打开了我们为什么扫描不到呢？
 原因是IOS对与ANCS服务做了特殊的限制，只有**同ios设备进行连接和绑定的设备才能后发现ANCS.**

ios蓝牙的限制我们都知道，那么如何才能够同ios设备进行连接和绑定呢？
 这里我给出的解决方案是：

1. ios设备上需要虚拟一个ble周边设备。可以通过调用gatt server的api自己实现app，或者下载lightblue。
2. 扫描到ios设备上的自己虚拟出来的周边设备后，跟该设备绑定。

```cpp
//android提供的代码如下：
BluetoothDevice device;
device.createBond();
```

1. 连接到该设备

```bash
device.connectGatt(getApplicationContext(), false, mGattCallback);
```

1. 连接成功后，就能够获得ANCS service了

```undefined
BluetoothGattService ancsService = gatt.getService(UUID.fromString(Constants.service_ancs));
```

### ANCS的操作

这个在*[苹果通知中心服务ANCS协议分析](https://www.jianshu.com/p/2ddf76ab85b0)*这篇文章中已经做了详细的描述，这里只是简单的梳理一下：

##### 获取通知的基本的信息：

订阅**Notification Source**特性，可以在**Notification Source**特性中读取通知的基本信息。

- 通知的事件类型（增删改三种），很容易理解，ios设备产生了通知就是add；ios设备上查看了该通知，就会产生一个remove事件。
- 通知的事件标志：可以从这个参数中看出ios设备给出的通知级别，以及可以对该通知执行的动作（这个稍后详解）。
- 通知的范畴或者翻译做种类？总之就是告诉你是个什么通知，比如是消息，来电，未接来电，邮件，新闻等，总共定义了12种。
- 该种类通知的活跃数量：就是几条未接来电啊之类。
- UID：该通知的唯一标示。

##### 获取通知的详细信息：

首先订阅 **Data Source**特性，然后往 **Control Point**中写入获得通知属性的命令，然后在 **Data Source**中读取通知详细信息的数据包。
 写入命令的格式的示例，当然可以获得属性不止这些：

```csharp
byte[] getNotificationAttribute = { 
    //规定为０ 
    (byte) 0x00, 
    //UID，通知的id 
    uid[0], uid[1], uid[2], uid[3], 
    //title,Attribute 1,第一条属性，通知的标题 
    (byte) 0x01, (byte) 0xff, (byte) 0xff, 
    //message，第二条属性，标题的消息 
    (byte) 0x03, (byte) 0xff, (byte) 0xff
};
```

从**Data Source**中读取的数据包格式

![Xnip2020-11-06_14-07-43](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_14-07-43.jpg)
 前面文章中有说到这个数据包的长度如果超过最大长度就会被分为多段发送，这个最大长度经亲测为20byte。
 而为了最大的有效信息的传输，除了第一个分段中包含commandID,Notification这两个重要的标示信息外，后面的分段并不包含这些，而是直接跟数据信息，也就是说你把拿到的所有分段直接组合起来就是完整的数据包，但是那个分段是最后的结束分段要通过参数的长度进行计算。

##### 对通知执行特定的动作：

很容易理解，我们使用智能手表可以代接ios的消息，手表查看后，ios中的该信息的通知消失，这个消失的动作就是针对消息型通知的特定动作；而对于来电而言，就可以有接听来电和拒绝接听两种操作。
 ANCS将特定动作分为negative action和positive action，但这里有两个问题需要特别注意：

- 特定动作是NC请求NP去执行的，也就是说，动作是在NP上面执行。
- negative action和positive action对于不同类型的通知代表的含义是不同的，比如negative action对于来电就是拒绝接听，而对于信息类型来说就是删除通知。
- 并不是每一个通知都可以执行这两种动作，比如消息类型的通知就只能执行negative动作，具体NC能够去请求执行哪些动作，NP会告知你，下面进行详解。

前面**获取通知的基本的信息**这一节中基本信息的第二项是事件标志位eventFlags，它占一个字节，也就是8bit，这8bit每一位都表示一种属性。

```undefined
EventFlagSilent = (1 << 0),
EventFlagImportant = (1 << 1),
EventFlagPreExisting = (1 << 2),
EventFlagPositiveAction = (1 << 3),
EventFlagNegativeAction = (1 << 4),
Reserved EventFlags = (1 << 5)–(1 << 7)
```

由此可知，我们可以通过查看其第4、５位是否为１来判断该通知可以执行什么动作。