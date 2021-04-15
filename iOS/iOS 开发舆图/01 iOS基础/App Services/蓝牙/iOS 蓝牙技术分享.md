---
title: iOS 蓝牙技术分享
tags: 蓝牙
categories: 蓝牙
abbrlink: 9700
date: 2018-03-24 12:01:03
---

0x01 - 概览

蓝牙技术最初由爱立信创制。技术始于爱立信公司的1994方案，它是研究在移动电话和其他配件间进行低功耗、低成本无线通信连接的方法。发明者希望为设备间的通讯创造一组统一规则（标准化协议），以解决用户间互不兼容的移动电子设备。从早期的1.0到目前最新的5.0版本，中间经过了十几年的发展。我们这里着重关注的是蓝牙4.0以及4.0之后的规范，蓝牙4.0于2010年7月7号推出，4.0之前的蓝牙统称为`经典蓝牙`，4.0之后又加入了低功耗功能并且有效的传输距离拓展到了最大的60米。

# 0x02 - 蓝牙的功能、类型与局限

**1）蓝牙的功能**

- 可同时传输语音和数据

<!-- more -->

蓝牙采用电路交换和分组交换技术，支持异步数据信道、三路语音信道以及异步数据与同步语音同时传输的信道。

- 可以建立临时性的对等连接

根据蓝牙设备在网络中的角色，可分为主设备 (Master)与从设备(Slave)。主设备是组网连接主动发起的设备，其余的为从设备。

- 低功耗

蓝牙设备在通信连接状态下，有四种工作模式:`激活(Active)模式`、`呼吸(Sniff)模式`、`保持(Hold)模式`、`休眠(Park)模式`；Active模式是正常的工作状态，另外三种模式是为了节能所规定的低功耗模式。

- 蓝牙模块体积小、便于集成

目前的移动设备有越做越小的趋势，小模块的蓝牙就更有利于嵌入移动设备内部。

- 标准的开放接口

蓝牙的标准是IEEE 802.15.1，蓝牙协议工作在无需许可的ISM（Industrial Scientific Medical）频段的2.45GHz。SIG 为了推广蓝牙技术的使用，将蓝牙的技术标准全部公开，全世界范围内的任何单位和个人都可以进行蓝牙产品的开发，只要最终通过SIG的蓝牙产品兼容性测试，就可以推向市场。

- 成本低

随着市场需求的扩大，各个供应商推出自己的蓝牙芯片和模块，蓝牙产品价格飞速下降。

**2）蓝牙的类型**

- [蓝牙基础率/增强数据率 (BR/EDR)](https://web.archive.org/web/20171207140908/https://www.bluetooth.com/zh-cn/what-is-bluetooth-technology/how-it-works/br-edr)，以点对点（P2P）网络拓扑结构建立一对一（1:1）设备通信，主要用于无线扬声器、耳机和免提车载系统；
- [低功耗 (LE) 蓝牙](https://web.archive.org/web/20171207140908/https://www.bluetooth.com/zh-cn/what-is-bluetooth-technology/how-it-works/le-p2p)，使用多个网络拓扑结构，包括点对点、广播和网格，主要用于健身追踪器、健康监测仪等物联网设备产品。

> 差异：
>
> `蓝牙 BR/EDR`：可建立相对较短距离的持续无线连接，因此非常适用于流式音频等应用
>
> `蓝牙 LE`：可建立短时间的长距离无线连接，非常适用于无需持续连接但依赖电池具有较长寿命的的物联网 (IoT) 应用
>
> `双模`：双模芯片可支持需要连接 BR/EDR 设备（例如音频耳机）以及 LE 设备（例如穿戴设备或零售信标）的单一设备（例如智能手机或平板电脑）

**特别需要注意的一点是：**

对于单模的`经典蓝牙`和`低功耗蓝牙`是**不能相互通信的**。所以在选型的时候需要特别注意，是选择单模的还是双模的，单模的话需要同是经典蓝牙或者低功耗蓝牙才行。市面上的绝大多数手机都是双模的。

**3）蓝牙的局限**

- 抗干扰能力不强

Bluetooth在2.4GHz的电波干扰问题一直为大家所诟病，特别和无线局域网间的互相干扰问题。当干扰发生时，一般的解决方式就以重新发送数据包来解决干扰。

- 传输速率不高

经典蓝牙是 1~3Mb/s ，低功耗蓝牙是 1Mb/s

> Note：实际测试并没有达到这么高，iphone 7 plus -> iphone x , 获取到的`maximumUpdateValueLength`属性值为`524 bytes/packet`(不同机型值不一样)，超过 524 字节的部分将被丢弃，实测一秒钟可以发80个包上下，MTU 在 `40.9Kb/s` 左右。

- 数据吞吐量不高

经典蓝牙是 0.7-2.1 Mb/s，低功耗蓝牙是 0.2 Mb/s

参考来源：[蓝牙-维基百科](https://zh.wikipedia.org/wiki/藍牙)

# 0x03 - 应用

这里主要讨论`蓝牙4.0`及以上的使用，并不是所有手机都支持蓝牙4.0技术，iPhone需要4S以上的手机，安卓需要系统4.3及以上的版本才OK。

![Xnip2020-11-07_10-42-43](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-42-43.jpg)



开发之前，iOS 10.0之后的系统都需要在`Info.plist`里面添加请求使用蓝牙功能模块的key `NSBluetoothPeripheralUsageDescription`，否则会导致功能不可用或者是崩溃！

如上图，蓝牙模块的主要核心是由`Central`和`Peripheral`组成。

- `Central` ： 主要负责发现和连接外设，读写外设的数据
- `Peripheral` ： 主要负责监测收集、对外广播和发送数据。

![Xnip2020-11-07_10-43-13](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-43-13.jpg)

`CBPeripheral`是由一个或者多个`CBService`组成，`CBService`又是由多个`CBCharacteristic`组成。

- `CBService` ： Peripheral 对外提供的服务，是一组功能或数据的集合；
- `CBCharacteristic` ： CBService 的子集，某个功能的具体特性，用于存放收集的的数据。

从CS架构模式来看 CoreBluetooth 提供的 Central 和 Peripheral。刚开始看的时候很容易把 Central 理解成 Server，其实刚好相反，Peripheral 才是我们的 Server。

如 (图 1-1) 所示，Peripheral 和 Central 之间建立的是一对多的关系。每个Peripheral 会以广播的模式告诉外界自己能提供哪些 Service，这里 Service 的概念和我们传统CS架构当中的 Service 基本是一致的，每个 PeriPheral 可以提供多个 Service，而每个 Service 呢，会包含多个 characteristic，characteristic 是个陌生但十分关键的概念，可以把 characteristic 理解成一个 Service 模块具体提供哪些服务，比如一个心率监测 Service 同时包含心率测量 characteristic 和地理位置定位 characteristic。

![Xnip2020-11-07_10-44-00](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-44-00.jpg)

**Peripheral 作为 Server，Central 作为 Client，Peripheral 广播自己的 Service和 characteristic，Central 订阅某一个具体的 characteristic，Peripheral 就和Central 之间通过 characteristic 建立了一个双向的数据通道**，整个模型非常简洁而且符合我们CS的架构体系。

接下来具体看下 CoreBluetooth 的相关API

## Server 端

### Peripheral

> 1. 创建 Peripheral ，也就是我们的 Server
> 2. 生成 Service 以备添加到 Peripheral 中
> 3. 生成 characteristics 以备添加到 Service 中
> 4. 建立 Peripheral、Service、characteristics 三者之间的关系并开始广播服务

- **创建 Peripheral ，也就是我们的 Server**

```
_peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
```

- **生成 Service 以备添加到 Peripheral 中**

```
CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] primary:YES];
```

- **生成 characteristics 以备添加到 Service 中**

```
self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyNotify|CBCharacteristicPropertyWrite
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
```

- **建立 Peripheral、Service、characteristics 三者之间的关系并开始广播服务**

```
//建立关系
transferService.characteristics = @[self.transferCharacteristic];
[self.peripheral addService:transferService];
//开始广播
[self.peripheral startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
```

## Client 端

### Central

> 1. 创建 Central
> 2. 扫描可用的 Peripheral
> 3. 连接 Peripheral
> 4. 连接之后查找 Peripheral 下可用的 Service
> 5. 找到 Service 之后，进一步查找需要的 Characteristics 并订阅

- **创建 Central:**

```
_central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
```

- **扫描可用的 Peripheral:**

```
[self.central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                         options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
```

- **扫描到 Peripheral 之后连接:**

```
[self.central connectPeripheral:targetPeripheral options:nil];
```

- **连接之后查找 Peripheral 下可用的 Service：**

```
[peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
```

- **找到 Service 之后，进一步查找需要的 Characteristics 并订阅:**

```
//查找Characteristics
[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
//订阅
[peripheral setNotifyValue:YES forCharacteristic:characteristic];
```

订阅之后 Central 和 Peripheral 之间就建立了一个双向的数据通道，后续二者之间的数据传输(读写)就可以通过 characteristic 来完成了。

## 数据传输

先看下 Peripheral 是如何向 Central 发送数据的，当数据有更新的时候 Peripheral 会向自己的 characteristics 写数据。

```
[self.peripheral updateValue:data forCharacteristic:self.transferCharacteristic onSubscribedCentrals:@[self.central]];
```

Central 之前有订阅过该 characteristics ，当 characteristics 有变化的时候，Central 那一端通过回调会收到来自 Peripheral 的数据流：

```
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
```

当 Central 需要对 Peripheral 回写数据的时候，则通过调用如下的接口进行：

```
[self.discoveredPeripheral writeValue:data forCharacteristic:self.discoveredCharacterstic type:CBCharacteristicWriteWithoutResponse];
```

Peripheral 端会收到如下回调：

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests
```

通过读取 request 中的 value 就可以获取到 Central 发送过来的数据了。

**对于少量的数据传输，使用以上的接口便可以满足我们的需求，当对于固件升级（Air OTA）这种需要传输大量数据的，有什么好的方案可以实现呢？**

[WWDC 2017: What’s New in Core Bluetooth](https://developer.apple.com/videos/play/wwdc2017/712/) 里面已经有做了详尽的介绍了，我这边就稍作一下总结：

首先我们来看一个图：

![Xnip2020-11-07_10-44-16](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-44-16.jpg)

低功耗蓝牙标准协议里面定义了最大的 MTU 为 `27 Bytes`，packet 在向下传输的时候，经过`通用属性 GATT(Generic Attribute Profile)`、`属性协议 ATT(Attribute Protocol)`又会损耗掉`7 Btyes`，所以**一个包最终可用的最大传输 MTU 为 20 Bytes。**并且，一旦你的数据通过了控制器，硬件又会添加链路层安全并且 CRC 也会延长传输数据包的时间

为了提高传输数据量，苹果又做了哪些优化呢？

- **提高单位时间内的写入次数（Write Without Response）**
- **拓展数据长度(Extended Data Length),蓝牙4.2之后支持**
- **L2CAP + EDL**
- **缩短请求间隔**

**提高单位时间内的写入次数（Write Without Response）**

![Xnip2020-11-07_10-44-36](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-44-36.jpg)

如上图，正常写入一个数据包需要花费 2 个时间间隔（一个时间间隔用于写入，一个时间间隔用于回复），这种方式的写入是非常稀疏的，并没有很好地利用可用的带宽。

Core Bluetooth 在底层做了一个可靠的`可持续写入`且`不需要等回包`的机制，以增加单位时间内写入的频次，提高发送的数据量。

根据苹果官方说法，只要根据文档配置API就可以安全可靠的发送数据：

```
CB_EXTERN_CLASS @interface CBPeripheral : CBPeer

- (NSUInteger)maximumWriteValueLengthForType:(CBCharacteristicWriteType)type NS_AVAILABLE(10_12, 9_0);

@end
CB_EXTERN_CLASS @interface CBCentral : CBPeer
@property(readonly, nonatomic) NSUInteger maximumUpdateValueLength;
@end
```

具体的 MTU 则是系统根据连接事件长度和系统配置来计算的。另外，外设也必须支持最大 MTU 以达到最大的数据吞吐量。

**拓展数据长度(蓝牙4.2之后才支持)**

相比之前的 27 bytes，4.2 之后的数据包支持最大`251 bytes`，单是一个数据包就提高了 9 倍多了，再加上不回包持续写入的优化，整整提高了10倍的传输量。

![Xnip2020-11-07_10-44-51](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-44-51.jpg)

**L2CAP + EDL**

![Xnip2020-11-07_10-45-07](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-45-07.jpg)

直接去掉了 GATT，ATT 的限制(比如限制最大属性大小为 512)，所以我们现在能够写入更大的值，也可以使用更大的 MTU，数据的吞吐量也会增加很多，达到 `200 kbps` 左右。

**缩短连接间隔（Faster Connection Interval）**

在 Core Bluetooth 中，请求连接的间隔是15ms，所以当你在更新你的固件的时候，你可以请求一个参数更新并将时间间隔的最小值和最大值设置为15ms。

![Xnip2020-11-07_10-45-22](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-07_10-45-22.jpg)

从上面这张图可以看到，要做固件升级的话最优的解决方案是：`L2CAP+EDL+15ms`

## 后台处理

由于 iOS 系统对后台运行做了很多限制，所以必须明确你开发的 App 是属于前台 App 还是后台App 还是二者都要支持的。

默认情况下，不管是Central还是Peripheral，当App处于后台或者被挂起的时候蓝牙功能都是无法使用的。因此，你需要显示的去设置后台运行模式。

- `Info.plist` 添加`UIBackgroundModes`的key，value 根据需要如果是Central就设置为`bluetooth-central`；如果是 Peripheral 就设置为`bluetooth-peripheral`

### 后台 Central

在后台运行 Central 的时候，它还是跟前台一样可以发现和连接到外设，并且和外设进行交互读写数据，但在扫描时候还是有点不同：

- 扫描可选key `CBCentralManagerScanOptionAllowDuplicatesKey` 会被忽略，扫描到的多个广播信号会被合并成一个事件；
- 后台模式下，扫描的时间间隔会变长，因此会比前台花更多的时间去发现外设。

### 后台 Peripheral

同样的，后台 Peripheral 也可以进行广播，接收连接请求，读写数据。当广播信号的时候还是跟前台有点不同：

- 广播的key`CBAdvertisementDataLocalNameKey` 会被忽略，外设的本地名字不会被广播；
- 包含`CBAdvertisementDataServiceUUIDsKey`key的服务UUIDSs被放置在一个“溢出”区域，它们只能被显式扫描它们的iOS设备所发现；
- 后台模式下，发送广播包的数量会减少。

### 在后台执行长（long-term）任务

想象一个这样的场景，你开发了一款由蓝牙开门的App，当你走近门的时候就自动连接并解锁。远离门的时候断开连接就锁上了。当用户长时间离开家或者出差几天，这时候App会被系统挂起或者杀死，当你回到家的时候需要App能够自动被唤醒然后解锁门。

对于这种类似的App，就需要蓝牙在后台能够长时间保活。

Core BlueBooth 利用`状态的保存和恢复`来解决这种问题。可以通过制定一个唯一的标识符，要去系统在挂起或者杀死App的时候保存当前的状态，然后在恢复的时候使用这个标识符恢复到被杀死前的状态，以达到长时间“保活”的目的。

### 添加状态保存和恢复支持

Core Bluetooth中的状态保存与恢复是可选的特性，需要程序的支持才能工作。我们可以按照以下步骤来添加这一特性的支持：

1. (必要步骤)当分配及初始化Central或Peripheral管理器对象时，选择性加入状态保存与恢复。
2. (必要步骤)在系统重启程序时，重新初始化Central或Peripheral管理器对象
3. (必要步骤)实现适当的恢复代理方法
4. (可选步骤)更新Central或Peripheral管理器初始化过程

**选择性加入状态保存与恢复**

在初始化 Central 的时候指定存储的key `CBCentralManagerOptionRestoreIdentifierKey`

```
myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey: @"myCentralManagerIdentifier" }];
```

**重新初始化Central或Peripheral管理器对象**

当系统在后台重启程序时，我们所需要做的第一件事就是使用恢复标识来重新初始化这些对象。我们可以通过在程序代理对象的`application:didFinishLaunchingWithOptions:`方法中，使用合适的启动选项键来访问管理器对象的列表。

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSArray *centralManagerIdentifiers = launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    
    // TODO: ...
    
    return YES;
}
```

有了这个恢复标识的列表后，我们就可以重新初始化我们所需要的管理器对象了。

**实现适当的恢复代理方法**

重新初始化Central或Peripheral管理器对象后，我们通过使用蓝牙系统的状态同步这些对象的状态来恢复它们。此时，我们需要实现一些恢复代理方法。对于`Central`管理器，我们实现`centralManager:willRestoreState:`代理方法；对于`Peripheral`管理器管理器，我们实现`peripheralManager:willRestoreState:`代理方法。

> Note:
> 对于选择性加入保存与恢复特性的应用来说，这些方法是程序启动到后台以完成一些蓝牙相关任务所调用的第一个方法。而对于非选择性加入特性的应用来说，会首先调用`centralManagerDidUpdateState:`和`peripheralManagerDidUpdateState:`代理方法。

```
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state
{
    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    
    // TODO: ...
}
```

通过`CBCentralManagerRestoredStatePeripheralsKey`键来获取Central管理器已连接的或尝试连接的所有Peripheral设备的列表，获取到这个列表后，我们便可以根据需要来做处理。

**更新初始化过程**

在实现了前面的三个步骤后，我们可能想更新我们的管理器的初始化过程。虽然这一步是可选的，但如果要确认任务是否运行正常时会非常有用。例如，我们的程序可能在解析所连接的Peripheral设备的数据的过程中被关闭。当程序使用这个Peripheral设备作恢复操作时，无法知道数据处理到哪了。我们需要确保程序从数据操作停止的位置继续开始操作。

如下面的代码展示了在`centralManagerDidUpdateState:`代理方法中初始化程序操作时，我们可以找出是否成功发现了被恢复的Peripheral设备的指定服务：

```
NSUInteger serviceUUIDIndex = [peripheral.services indexOfObjectPassingTest:^BOOL(CBService *obj, NSUInteger index, BOOL *stop) {
        return [obj.UUID isEqual:myServiceUUIDString];
    }];


    if (serviceUUIDIndex == NSNotFound) {
        [peripheral discoverServices:@[myServiceUUIDString]];
        ...
}
```

如上例所述，如果系统在程序完成搜索服务时关闭了应用，则通过调用`discoverServices:`方法在关闭的那个点开始解析恢复的Peripheral数据。如果程序成功搜索到服务，我们可以确认是否搜索到正确的特性。通过更新初始化过程，我们可以确保在正确的时间调用正确的方法。

虽然我们可能需要声明应用支持Core Bluetooth后台执行模式，以完成特定的任务，但总是应该慎重考虑执行后台操作。因为执行太多的蓝牙相关任务需要使用iOS设备的内置无线电，而无线电的使用会影响到电池的寿命，所以尽量减少在后台执行的任务。任何会被蓝牙相关任务唤醒的应用应该尽快处理任务并在完成时重新挂起。

下面是一些基础的准则：

1. 应用应该是基于会话的，并提供接口以允许用户决定什么时候开始及结束蓝牙相关事件的分发。
2. 一旦被唤醒，一个应用大概有10s的时间来完成任务。理想情况下，应用应该尽快完成任务并重新挂起。系统可以对执行时间太长的后台任务进行限流甚至杀死。
3. 应用被唤醒时，不应该执行一些无关紧要的操作。

参考链接：

[About Core Bluetooth](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)

[Performing Common Role Central Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW1)

[Core Bluetooth Programming Guide](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html#//apple_ref/doc/uid/TP40013257-CH7-SW1)

[WWDC 2017: What’s New in Core Bluetooth](https://developer.apple.com/videos/play/wwdc2017/712/)

[BLE(低功耗蓝牙)中ATT协议简介](https://blog.csdn.net/guodaye5200/article/details/58587885)