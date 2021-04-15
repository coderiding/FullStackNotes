---
title: 『CoreBluetooth』4. 作为 Central 时的数据读写（最佳实践）
tags: 蓝牙
categories: 蓝牙
abbrlink: 31492
date: 2016-06-14 09:14:23
---

之前介绍了比较多的基础内容吧，本文会结合 API 中的最佳实践和自己在开发中遇到的问题来谈谈需要注意的地方。当然，文本中的设备依然是作为 central 的。如果只看这篇文章有不明白的话，可以先参考前几篇文章：

CoreBluetooth1 初识
CoreBluetooth2 作为 Central 时的数据读写
CoreBluetooth3 作为 Central 时的数据读写（补充）
CoreBluetooth5 作为 Central 时的数据读写（OTA 固件升级与文件传输）

在设备上一般都有很多地方要用到无线电通信，Wi-Fi、传统的蓝牙、以及使用 BLE 通信的 app 等等。这些服务都是很耗资源的，尤其是在 iOS 设备上。所以本文会讲解到如何正确的使用 BLE 以达到节能的效果。

### 只扫描你需要的 peripheral
在调用 CBCentralManager的 scanForPeripheralsWithServices:options:方法时，central 会打开无线电去监听正在广播的 peripheral，并且这一过程不会自动超时。（所以需要我们手动设置 timer 去停掉，文后会提到）

如果只需要连接一个 peripheral，那应该在 centralManager:didConnectPeripheral:的回调中，用 stopScan方法停止搜索。

### 只在必要的时候设置 CBCentralManagerScanOptionAllowDuplicatesKey
peripheral 每秒都在发送大量的数据包，scanForPeripheralsWithServices:options:方法会将同一 peripheral 发出的多个数据包合并为一个事件，然后每找到一个 peripheral 都会调用 centralManager:didDiscoverPeripheral:advertisementData:RSSI:方法。另外，当已发现的 peripheral 发送的数据包有变化时，这个代理方法同样会调用。

以上合并事件的操作是 scanForPeripheralsWithServices:options:的默认行为，即未设置 option参数。如果不想要默认行为，可将 option设置为 CBCentralManagerScanOptionAllowDuplicatesKey。设置以后，每收到广播，就会调用上面的回调（无论广播数据是否一样）。关闭默认行为一般用于以下场景：根据 peripheral 的距离来初始化连接（距离可用信号强度 RSSI 来判断）。设置这个 option会对电池寿命和 app 的性能产生不利影响，所以一定要在必要的时候，再对其进行设置。



<!-- more -->

### 正确的搜索 service 与 characteristic
在 CoreBluetooth2 作为 Central 时的数据读写 中也提到过这个问题，在搜索过程中，并不是所有的 service 和 characteristic 都是我们需要的，如果全部搜索，依然会造成不必要的资源浪费。

假设你只需要用到 peripheral 提供的众多 service 的两个，那么在搜索 service 的时候可以设置要搜索的 service 的 UUID（打包为 CBUUID，关于 CBUUID的介绍可见 CoreBluetooth3 作为 Central 时的数据读写（补充））。

[peripheral discoverServices:@[firstServiceUUID, secondServiceUUID]];
用这种方式搜索到 service 以后，也可以用类似的办法来限制 characteristic 的搜索范围（discoverCharacteristics:forService:）。

### 接收 characteristic 数据
接收 characteristic 数据的方式有两种：

* 在需要接收数据的时候，调用 readValueForCharacteristic:，这种是需要主动去接收的。
* 用 setNotifyValue:forCharacteristic:方法订阅，当有数据发送时，可以直接在回调中接收。
* 如果 characteristic 的数据经常变化，那么采用订阅的方式更好。

### 适时断开连接
在不用和 peripheral 通信的时候，应当将连接断开，这也对节能有好处。在以下两种情况下，连接应该被断开：

* 当 characteristic 不再发送数据时。（可以通过 isNotifying属性来判断）
* 你已经接收到了你所需要的所有数据时。
* 以上两种情况，都需要先结束订阅，然后断开连接。

```
[peripheral setNotifyValue:NO forCharacteristic:characteristic];
[myCentralManager cancelPeripheralConnection:peripheral];
```

注意：cancelPeripheralConnection:是非阻塞性的，如果在 peripheral 挂起的状态去尝试断开连接，那么这个断开操作可能执行，也可能不会。因为可能还有其他的 central 连着它，所以取消连接并不代表底层连接也断开。从 app 的层面来讲，在 peripheral 决定断开的时候，会调用 CBCentralManagerDelegate 的 centralManager:didDisconnectPeripheral:error:方法。

### 再次连接 peripheral
Core Bluetooth 提供了三种再次连接 peripheral 的方式：

* 调用 retrievePeripheralsWithIdentifiers:方法，重连已知的 peripheral 列表中的 peripheral（以前发现的，或者以前连接过的）。
* 调用 retrieveConnectedPeripheralsWithServices:方法，重新连接当前【系统】已经连接的 peripheral。
* 调用 scanForPeripheralsWithServices:options:方法，连接搜索到的 peripheral。
是否需要重新连接以前连接过的 peripheral 要取决于你的需求，下图展示了当你尝试重连时可以选择的流程：

![Xnip2020-11-06_09-05-02](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_09-05-02.jpg)

三列代表着三种重连的方式。当然这也是你可以选择进行实现的，这三种方式也并不是都需要去实现，依然取决于你的需求。

### 尝试连接已知的 peripheral
在第一次成功连上 peripheral 之后，iOS 设备会自动给 peripheral 生成一个 identifier （NSUUID类型），这个标识符可通过 peripheral.identifier来访问。这个属性由 CBPeriperal的父类 CBPeer提供，API 注释写着:

>The unique, persistent identifier associated with the peer.

因为 iOS 拿不到 peripheral 的 MAC 地址，所以无法唯一标识每个硬件设备，根据这个注释来看，应该 Apple 更希望你使用这个 identifer而不是 MAC 地址。值得注意的是，不同的 iOS 连接同一个 peripheral 获得的 identifier是不一样的。所以如果一定要获得唯一的 MAC 地址，可以和硬件工程师协商，让 peripheral 返给你。具体的场景我在上一篇文章中介绍过。

那么继续回到重新连接 peripheral 这个话题上来。当第一次连接上 peripheral 并且系统自动生成 identifier 之后，我们需要将它存下来（可以使用 NSUserDefaults）。在再次连接的时候，将 identifiers 读出来，调用 retrievePeripheralsWithIdentifiers:方法即可。

```
knownPeripherals = [myCentralManager retrievePeripheralsWithIdentifiers:savedIdentifiers];
```

调用这个方法之后，会返回一个 CBPeripheral的数组，包含了以前连过的 peripheral。如果这个数组为空，则说明没找到，那么你需要去尝试另外两种重连方式。如果这个数组有多个值，那么你应该提供一个界面让用户去选择。

如果用户选择了一个，那么可以调用 connectPeripheral:options:方法来进行连接，连接成功之后依然会走 centralManager:didConnectPeripheral:回调。

注意，连接失败通常有一下几个原因：

* peripheral 与 central 的距离超出了连接范围。
* 有一些 BLE 设备的地址是周期性变化的。所以，即使 peripheral 就在旁边，如果它的地址已经变化，而你记录的地址已经变化了，那么也是连接不上的。如果是因为这种原因连接不上，那你需要调用 scanForPeripheralsWithServices:options:方法来进行重新搜索。
更多关于随机地址的资料可以看 《苹果产品的蓝牙附件设计指南》。

### 连接系统已经连接过的 peripheral
另外一种重连的方式是通过检测当前系统是否已经连上了需要的 peripheral （可能被其他 app 连接了）。调用 retrieveConnectedPeripheralsWithServices:会返回一个 CBPeripheral的数组。

因为当前可能不止一个 peripheral 连上的，所以你可以通过传入一个 service 的 CBUUID的数组来过滤掉一些不需要的 peripheral 。同样，这个数组有可能为空，也有可能不为空，处理方式和上一节的方式相同。找到要连接的 peripheral 之后，处理方式也和上一节相同。

### 自动连接
可以再程序启动或者需要使用蓝牙的时候，判断是否需要自动连接。如果需要，则可以尝试连接已知的 peripheral。这个重连上一个小节刚好提到过：在上一次连接成功后，记录 peripheral 的 identifier，然后重连的时候，读取即可。

在自动连接这一块，还有一个小坑。在使用 retrievePeripheralsWithIdentifiers:方法将之前记录的 peripheral 读取出来，然后我们去调用 connectPeripheral:options:方法来进行重新连接。我之前怎么试都有问题，最后在 CBCentralManager的文档上找到了这样一句话：

>Pending connection attempts are also canceled automatically when peripheral is deallocated.

这句话的意思是说，在 periperal 的引用释放之后，连接会自动取消。因为我在读取出来之后，接收的 CBPeripheral是临时变量，没有强引用，所以出了作用域就自动释放了，从而连接也自动释放了。所以在自动连接的时候，读取出来别忘了去保存引用。

### 连接超时
因为 Core Bluetooth 并未帮我们处理连接超时相关的操作，所以超时的判断还需要自己维护一个 timer。可以在 start scan 的时候启动（注意如果是自动连接，那么重连的时候也需要启动），然后在搜索到以后 stop timer。当然，如果超时，则看你具体的处理方式了，可以选择 stop scan，然后让用户手动刷新。

### 蓝牙名称更新
在 peripheral 修改名字过后，iOS 存在搜索到蓝牙名字还未更新的问题。先来说一下出现这个问题的原因，以下是摘自 Apple Developer Forums 上的回答：

>There are 2 names to consider. The advertising name and the GAP (Generic Access Profile) name.

For a peripheral which iOS has never connected before, the ‘name’ property reported is the advertising name. Once it is connected, the GAP name is cached, and is reported as the peripheral’s name. GAP name is considered a “better” name due to the size restrictions on the advertising name.

There is no rule that says both names must match. That depends on your use case and implementation. Some people will consider the GAP name as the fixed name, but the advertising name more of an “alias”, as it can easily be changed.

If you want both names in sync, you should change the GAP name as well along with the advertised name. Implemented properly, your CB manager delegate will receive a call to - peripheralDidUpdateName:

If you want to manually clear the cache, you need to reset the iOS device.

大致意思是：peripheral 其实存在两个名字，一个 advertising name，一个 GAP name。在没有连接过时，收到的 CBPeripheral 的 name 属性是 advertising name（暂且把这个名字称为正确的名字，因为在升级或换名字之后，这个名字才是最新的）。一旦 iOS 设备和 peripheral 连接过，GAP name 就会被缓存，与此同时，CBPeripheral 的 name 属性变成 GAP name，所以在搜索到设备时，打印 CBPeripheral 的 name，怎么都没有变。上文给出的解释是，因为数据大小限制，GAP name 更优于 advertising name。这两个名字不要求要相同，并且，如果要清除 GAP name 的缓存，那么需要重置 iOS 设备。

下面来说一下解决方案，主要分为两种，一种是更新 GAP name，一种是直接拿 advertising name。

更新 GAP name 的方式我目前没找到方法，有些人说是 Apple 的 bug，这个还不清楚，希望有解决方案的朋友联系我。

那就来说下怎么拿到 advertising name 吧。centralManager:didDiscoverPeripheral:advertisementData:RSSI: 方法中可以通过 advertisementData 来拿到 advertising name，如下：

```
NSLog(@"%@", advertisementData[CBAdvertisementDataLocalNameKey]);
```

然后可以选择把这个 name 返回外部容器来进行显示，用户也可以通过这个来进行选择。不过依然觉得有点坑，还希望大家能帮我解答这个问题。

关于这个部分查找的资料有：

>CoreBluetooth: Refreshing local name of an already discovered Peripheral
>Incorrect BLE Peripheral Name with iOS
>Bluetooth name caching