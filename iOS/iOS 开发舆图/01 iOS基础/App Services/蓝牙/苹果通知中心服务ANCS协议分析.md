---
title: 苹果通知中心服务ANCS协议分析
tags: 蓝牙
categories: 蓝牙
abbrlink: 18117
date: 2016-06-12 12:01:03
---

> 苹果ANCS官网ANCS spec：
>  [https://developer.apple.com/library/content/documentation/CoreBluetooth/Reference/AppleNotificationCenterServiceSpecification/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013460-CH2-SW1](https://link.jianshu.com?t=https://developer.apple.com/library/content/documentation/CoreBluetooth/Reference/AppleNotificationCenterServiceSpecification/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013460-CH2-SW1)

此文大部分内容来自官方的翻译，加上了自己的一些蹩脚的理解。

### 一、简介

ANCS是Apple Notification Center Service的简称，中文为苹果通知中心服务。
 ANCS是苹果让周边蓝牙设备（手环、手表等）可以通过低功耗蓝牙访问IOS设备（iphone、ipad等）上的各类通知提供的一种简单方便的机制。

##### 依赖

ANCS是基于BLE协议中的通用属性协议（Generic Attribute Profile,GATT）协议实现的，他是GATT协议的一个子集。在ANCS协议中，IOS设备作为gatt-server,而周边设备作为gatt client来连接和使用server提供的其他services。

##### 端和字符编码

除非特殊说明，IOS设备ANCS与ble设备进行通信的过程中都是采用的小端模式进行传输的，比如NC接收到的attribute length数据为0x02 0x00,应该解析为0x00 0x02，即长度为2byte.
 字符串的编码采用了UTF-8编码格式。

<!-- more -->

##### 相关术语

NP（Notification Provider）:消息提供者，指的是ANCS服务的产生者，即IOS设备。
 NC（Notification Consumer）:消息接受者，指的是ANCS服务的客户端，即周边BLE设备。

### 二、ANCS

苹果通知中心服务的UUID为7905F431-B5CE-4E99-A40F-4B1E122D00D0。
 由于IOS的特性限制，一个苹果设备上只能有一个ANCS存在，一个ANCS可以连接多个client。因为ANCS并不能保证始终存在（be present？），NC需要订阅服务变更特性（the Service Changed characteristic of the GATT service ）以便任何时候都可以监听准备发布和取消发布的ANCS。

##### 服务特性

ANCS有三个特性：

- **Notification Source:** UUID 9FBF120D-6301-42D9-8C58-25E699A21DBD
   通知源，权限是可通知
- **Control Point:** UUID 69D1D8F3-45E1-49A8-9821-9BBDFDAAD9D9
   控制点，权限是可写入，可响应
- **Data Source:** UUID 22EAC6E9-24D6-4BB5-BE44-B36ACE7C7BFB
   数据源，权限是可通知

所有的特性需要认证（NC设备连接上NP并且完成配对和绑定）才能过连接。
 对于NC来说，通知源是必须订阅的，其他两个是可选择的。

##### 通知源

NC收到的通知源特性主要有三种事件：

- NP上新通知的到达
- NP上通知的修改
- NP上通知的删除
   当NC订阅了通知源特性时，这些通知将会立刻被分发。因此NC在订阅该特性时必须处于有能力接收和处理这些消息的状态。

![Xnip2020-11-06_13-53-13](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-53-13.jpg)

数据源特性分发的通知的格式

经过数据源特性分发的Gatt通知包含一下信息：

- **EventID**：这个字段指明了iOS通知添加、修改或移除三种事件中的一种。该字段的枚举值可参考后面附录的EventID Value表。
- **EventFlags**：一个位掩码，这个位掩码表明了这个通知的一种特征。例如，如果一个通知被认为是重要的，那么NC收到这个通知后，就想用明显的方式提醒用户。位掩码的枚举值在后面的EventFlags表中。
- **CategoryID**：通知的种类，分为邮件，来电，未接来电，社交，娱乐等多种分类，短信和微信扣扣等消息全部在社交（social）。
- **CategoryCount**：给定类型中活跃的通知的数量。例如，邮箱中有两封未读的邮件，这个时候又来了一封新的邮件，那么通知的邮件的数量将是3。
- **NotificationUID**：该通知的id，一个32位的数字来作为通知的唯一标示（UID）。获取更多该通知的信息时，这个数值在将作为命令中的一个句柄写入控制点特性（即告诉控制点我想要获得那条通知的详细信息）。

![Xnip2020-11-06_13-53-37](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-53-37.jpg)

IOS通知的生命周期

##### 控制点和数据源

NC设备可能想要与IOS通知进行交互。它可能需要获得通知的更多信息，其中包括它的内容以及在此基础上进行一些操作，这些都要通过控制点和数据源特性来实现。

NC可以通过往控制点特性里写入命令来获取关于通知的更多消息。如果命令写入成功的话，NP会在数据源特性中通过通知流对该请求进行回复。

**获取通知具体属性的命令**
 获取通知属性命令使得NC可以得到某个特定通知的详细属性，比如短信的发送人，短信内容，时间等。

![Xnip2020-11-06_13-53-55](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-53-55.jpg)

通知属性获取命令的格式

该命令包含了一下的信息：

- **CommandID:** 设为零 (CommandIDGetNotificationAttributes)，0x00
- **NotificationUID:** 想要获得的通知的uid,32位数字是通知的唯一标示。
- **AttributeIDs:**NC想要获得的属性列表。有些属性可能需要后面接一个16位的的参数,0xff 0xff。

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

![Xnip2020-11-06_13-54-15](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-54-15.jpg)

针对通知属性获取命令的响应的格式

该响应包含一下内容：

- **CommandID:** 设为0 (CommandIDGetNotificationAttributes)。
- **NotificationUID:** 32位的UID。
- **AttributeList:**由属性ID、16位长度、属性所组成的一个列表。一个属性始终是字符串，并且它的长度由16位长度所决定，而不是以空(NULL)结束。如果所请求的属性是空的，或者是错过了iOS通知，那么长度设为0。

如果响应的长度大于GATT所规定的最大传输单元(Maximum Transmission Unit, MTU)，则NP会它分成多段传送。NC必须将响应的数据段重新组包。当收到所有请求属性的内容时，则表示响应完成。

**获得应用属性**
 获取应用属性命令允许NC指定获取NP上某个已安装的应用程序的属性。

![Xnip2020-11-06_13-54-32](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-54-32.jpg)

获取应用属性命令的格式

获取应用属性命令包含下面信息：

- CommandID：必须设置为1(CommandIDGetAppAttributes)。
- AppIdentifier：客户端想要获取信息的应用程序的字符串标志。字符串必须以空(NULL)结束。
- AttributeIDs：想要NC先要获取的属性列表。

![Xnip2020-11-06_13-54-48](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-54-48.jpg)

应用获取命令的响应的格式

响应一个获取应用属性命令的数据包含下面信息：

- CommandID：设置为1(CommandIDGetAppAttributes)。
- AppIdentifier：应用的字符串标识。字符串以空(NULL)结束。
- AttributeList：由属性ID、16位长度、属性所组成的一个列表。一个属性始终是字符串，并且它的长度由16位长度所决定，而不是以空(NULL)结束。如果所请求的属性是空的，或者错过了应用应用程序，那么长度设为0。

如果响应数据的长度大于GATT所规定的最大传输单元(Maximum Transmission Unit, MTU)，则NP会它分成多端传送。NC必须将响应的数据段重新组包。当收到所有请求属性的内容时，则表示响应完成。

**执行通知动作
 它允许NC向指定的iOS通知执行一条预定动作。

![Xnip2020-11-06_13-55-08](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-55-08.jpg)

执行通知动作命令格式

一条执行通知动作包含下面信息：

- CommandID：必须设置为2(CommandIDPerformNotificationAction)。
- NotificationUID：32位的数值。其值为要执行动作的的iOS通知的UID。
- ActionID：NC对指定iOS通知要执行的动作。

当发送这个命令到控制点特征后，无论发送成功或失败，数据源特征上都不会产生数据。也就是说这是一个无需响应的命令。

**通知动作**
 从iOS8开始，NP发送的iOS通知起始可以间接的告诉NC可执行哪些动作。接着，NC就可以针对指定的iOS通知，请求NP执行一个动作。
 通知源特征上生成的GATT通知包含一个叫做Eventflags的数据域，NC根据这个数据域就可得知对一条iOS通知可以执行哪些操作：

- EventFlagPositiveAction：积极动作(Positive Action)，与iOS通知相关。
- EventFlagNegativeAction：消极动作(Negative Action)，与iOS通知相关。

实际的动作都是由NP执行的，这就表示：NC可执行动作都是由NP所决定的，而且根据iOS通知的不同而不同。举个例子，当NC收到来电通知时，执行积极动作可以接听，执行消极动作就拒接，而对于消息（官方是social）类型的通知而言，则只有消极操作，也就是说，在手表等从设备上面只能查看消息，而无法回复。
 NC不能预先去假设或尝试猜测一条iOS通知确切的可执行的动作。因为这些动作都是基于特定通知的，只有NP知道，而对NC无用的；同时还有其它的因素，如ANCS版本的变化等。这样，NP才能保证积极动作和消极动作的结果都与用户没多大关系。
 iOS 8系统中，NC通过发送获取通知属性命令，可获取到某条iOS通知可执行动作的简洁描述：

- NotificationAttributeIDPositiveActionLabel：这条标签用于描述某条iOS通知可执行的积极动作。
- NotificationAttributeIDNegativeActionLavel：这条标签用于描述某条iOS通知可执行的消极动作。

### 三、生命周期

一个ANCS的服务周期开始于NC订阅NP上的Notification Source characteristic，结束于NC取消该订阅或者断开连接。因为ANCS不是一种完全同步的服务，它没有追踪不同周期中的状态，因此所有的标示以及NC、NP之间的数据交换只在某一个周期中是有效的。

当一个周期结束后，NC应该删除其在本周期内采集和存储的所有的标示以及数据。一个新的周期开始的时候，NP会可能的把所有存在的通知下发给NC。

### 四、错误码

当往 Control Point characteristic中写入控制命令时,NC有时会受到ANCS错误码：

**Unknown command** (0xA0): 命令无法识别.

**Invalid command** (0xA1): 命令格式错误.

**Invalid parameter** (0xA2): 参数错误，例如notification uid并不存在对应的notification对象.

**Action failed** (0xA3): 动作没有被执行。

如果NP回复了一个错误码，那么Data Source characteristic中将不再产生任何回应的命令的数据。

### 五、示例图

以下两个图展示了NP和NC之间的两种交互的过程的例子。Figure 2-7显示了NC上想要开启ANCS的基本流程；[Figure 2-8](https://link.jianshu.com?t=https://developer.apple.com/library/content/documentation/CoreBluetooth/Reference/AppleNotificationCenterServiceSpecification/Specification/Specification.html#//apple_ref/doc/uid/TP40013460-CH1-SW16) 展示了NC获得IOS通知更多信息的基本流程。

![Xnip2020-11-06_13-55-35](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-55-35.jpg)


![Xnip2020-11-06_13-56-11](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-56-11.jpg)

