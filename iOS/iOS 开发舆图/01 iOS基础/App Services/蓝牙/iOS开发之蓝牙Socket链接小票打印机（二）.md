---
title: iOS开发之蓝牙Socket链接小票打印机（二）
tags: 蓝牙
categories: 蓝牙
abbrlink: 18111
date: 2016-06-18 12:01:03
---

## 前言

[上一篇](https://link.jianshu.com?t=https%3A%2F%2Fzhaomengnan.top%2F2017%2F12%2F19%2FiOS%E5%BC%80%E5%8F%91%E4%B9%8B%E8%93%9D%E7%89%99%E5%B0%8F%E7%A5%A8%E6%89%93%E5%8D%B0%E6%9C%BA(%E4%B8%80)%2F)主要介绍了部分ESC/POS指令集，包括一些常用的排版指令，打印位图指令等。另外，还介绍了将图片转换成点阵图的方法。在这篇文章中，将主要介绍通过蓝牙和Socket连接打印机，发送打印指令相关知识。这里将用到`CoreBluetooth.framework`和`CocoaAsyncSocket`。

## 蓝牙链接小票打印机

### 简介

蓝牙是一种支持设备间短距离通讯的无线电技术。iOS系统中，有四个框架支持蓝牙链接：

- `GameKit.framework`： 只能用于iOS设备之间的连接，多用于蓝牙对战的游戏，iOS7开始已过期；
- `MultipeerConnectivity.framework`：只能用于iOS设备之间的连接，从iOS7开始引入，主要用于替代`GameKit`；
- `ExternalAccessory.framework`：可用于第三方蓝牙设备交互，但是蓝牙设备必须经过苹果MFi认证；
- `CoreBluetooth.framework`：目前最iOS平台最流行的框架，并且设备不需要MFi认证，手机至少4S以上，第三方设备必须支持蓝牙4.0；这里介绍的链接打印机就是使用此框架，因此开始前要确保打印机是支持蓝牙4.0的；

**CoreBluetooth框架有两个核心概念，central（中心）和 peripheral（外设），它们分别有自己对应的API；这里显然是手机作为central，蓝牙打印机作为peripheral；**

<!-- more -->

### 步骤

#### 1.初始化中心设备管理

```objectivec
self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
```

#### 2. 确认蓝牙状态

设置代理后，会回调此方法，确认蓝牙状态，当状态为`CBCentralManagerStatePoweredOn`才能去扫描设备，蓝牙状态变化时，也会回调此方法

```objectivec
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString * state = nil;
    
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn&#39;t support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            state = @"work";
            break;
        case CBCentralManagerStateUnknown:
        default:
            ;
    }
    
    NSLog(@"Central manager state: %@", state);
}
```

#### 3. 扫描外设

调用此方法开始扫描外设

注意：第一个参数指定一个`CBUUID`对象数组，每个对象表示外围设备正在通告的服务的通用唯一标识符（UUID）。此时，仅返回公布这些服务的外设。当参数为`nil`，则返回所有已发现的外设，而不管其支持的服务是什么。

```objectivec
[self.centralManager scanForPeripheralsWithServices:nil options:nil];
```

当扫描到4.0外设后会回调此方法，这里包含设备的相关信息，如名称、UUID、信号强度等；

```objectivec
/*
 扫描，发现设备后会调用
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *str = [NSString stringWithFormat:@"----------------发现蓝牙外设: peripheral: %@ rssi: %@, UUID:  advertisementData: %@ ", peripheral, RSSI,  advertisementData];
    NSLog(@"%@",str);
    if (![self.peripherals containsObject:peripheral]) {
        [self.peripherals addObject:peripheral];
    }
}
```

#### 4. 选择外设进行连接

调用此方法连接外设
 `[self.centralManager connectPeripheral:peripheral options:nil];`

注意：第一个参数是要连接的外设。第二个参数`options`是可选的`NSDictionary`,系统定义了一下三个键，它们的值都是NSNumber (Boolean)；默认为NO。当设置为YES，则应用进入后台或者被挂起后，系统会用Alert通知蓝牙外设的状态变化，效果是这样

![Xnip2020-11-05_18-13-21](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-13-21.jpg)

锁屏



![Xnip2020-11-05_18-13-39](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-13-39.jpg)

未锁屏

```undefined
CBConnectPeripheralOptionNotifyOnConnectionKey;连接时Alert显示
CBConnectPeripheralOptionNotifyOnDisconnectionKey;断开时Alert显示
CBConnectPeripheralOptionNotifyOnNotificationKey;接收到外设通知时Alert显示
```

```ruby
    [self.centralManager connectPeripheral:peripheral  options:@{
                                                                 CBConnectPeripheralOptionNotifyOnConnectionKey : @YES,
                                                                 CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES,
                                                                 CBConnectPeripheralOptionNotifyOnNotificationKey : @YES
                                                                 }];
```

连接成功或失败，都有对应的回调方法

```objectivec
/*
 连接失败后回调
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}
/*
 连接成功后回调
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;//设置代理
    [central stopScan];//停止扫描外设
    [peripheral discoverServices:nil];//寻找外设内所包含的服务
}
```

#### 5. 扫描外设中的服务和特征

连接成功后设置代理`peripheral.delegate = self`,调用`[peripheral discoverServices:nil];`寻找外设内的服务。这里的参数是一个存放`CBUUID`对象的数组，用于发现特定的服务。当传nil时，表示发现外设内所有的服务。发现服务后系统会回调下面的方法:

```objectivec
/*
 扫描到服务后回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService* service in  peripheral.services) {
        NSLog(@"扫描到的serviceUUID:%@",service.UUID);
        //扫描特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
```

发现服务后，调用`[peripheral discoverCharacteristics:nil forService:service];`去发现服务中包含的特征。和上面几个方法一样，第一个参数用于发现指定的特征。为nil时，表示发现服务的所有特征。

```objectivec
/*
 扫描到特性后回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic * cha in service.characteristics)
    {
        CBCharacteristicProperties p = cha.properties;
        if (p & CBCharacteristicPropertyBroadcast) {//广播特征
            
        }
        if (p & CBCharacteristicPropertyRead) {//读取特征
            self.characteristicRead = cha;
        }
        if (p & CBCharacteristicPropertyWriteWithoutResponse) {//无反馈写入特征

        }
        if (p & CBCharacteristicPropertyWrite) {//有反馈写入特征
            self.peripheral = peripheral;
            self.characteristicInfo = cha;
        }
        if (p & CBCharacteristicPropertyNotify) {//通知特征             
                self.characteristicNotify = cha;
                [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristicNotify];
            NSLog(@"characteristic uuid:%@  value:%@",cha.UUID,cha.value);
            
        }
    }
    
}
```

当扫描到写入特征时，保存，用于写入数据。

#### 6. 写入数据

写入数据，我们只需要调用方法

```objectivec
[self.peripheral writeValue:subData forCharacteristic:self.characteristicInfo type:CBCharacteristicWriteWithResponse];
```

这里的`self.peripheral`就是连接的外设，`self.characteristicInfo`就是之前保存的写入特征；这里最好使用`CBCharacteristicPropertyWrite`特征，并且`type`选择`CBCharacteristicWriteWithResponse`。当写入数据成功后，系统会通过下面这个方法通知我们：

```objectivec
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"＝＝＝＝error%@",error);
    }else{
        NSLog(@"＝＝＝＝写入成功  %@", characteristic);
    }
    
}
```

由于蓝牙设备每次可写入的数据量是有限制的，因此，我们需要将之前拼接的打印数据进行拆分，分批发送给打印机

```objectivec
- (void)printLongData:(NSData *)printContent{
    NSUInteger cellMin;
    NSUInteger cellLen;
    //数据长度
    NSUInteger strLength = [printContent length];
    if (strLength < 1) {
        return;
    }
    //MAX_CHARACTERISTIC_VALUE_SIZE = 120
    NSUInteger cellCount = (strLength % MAX_CHARACTERISTIC_VALUE_SIZE) ? (strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (int i = 0; i < cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        NSRange rang = NSMakeRange(cellMin, cellLen);
        //        截取打印数据
        NSData *subData = [printContent subdataWithRange:rang];
        //循环写入数据
        [self.peripheral writeValue:subData forCharacteristic:self.characteristicInfo type:CBCharacteristicWriteWithResponse];
    }
}
```

这里的`MAX_CHARACTERISTIC_VALUE_SIZE`是个宏定义，表示每次发送的数据长度，经笔者测试，当`MAX_CHARACTERISTIC_VALUE_SIZE = 20`时，打印文字是正常速度。但打印图片的速度非常慢，**应该在硬件允许的范围内，每次发尽量多的数据。**不同品牌型号的打印机，这个参数是不同的，笔者的蓝牙打印机该值最多到140。超出后会出现无法打印问题。**最后笔者将该值定为`MAX_CHARACTERISTIC_VALUE_SIZE = 120`，测试了公司几台打印机都没有问题。**

另外iOS9以后增加了方法`maximumWriteValueLengthForType:`可以获取写入特诊的最大写入数据量，但经笔者测试，对于部分打印机（比如我们公司的）是不准确的，因此，不要太依赖此方法，最好还是自己取一个合适的值。

**注意：每个打印机都有一个缓冲区，缓冲区的大小视品牌型号有所不同。打印机的打印速度有限，如果我们瞬间发送大量的数据给打印机，会造成打印机缓冲区满。缓冲区满后，如继续写入，可能会出现数据丢失，打印乱码。**

## Socket链接小票打印机

### 简介

这里使用[CocoaAsyncSocket](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Frobbiehanson%2FCocoaAsyncSocket)开源框架，与打印机进行`Socket`连接。`CocoaAsyncSocket`中主要包含两个类:

- `GCDAsyncSocket`:用GCD搭建的基于TCP/IP协议的socket网络库;
- `GCDAsyncUdpSocket`:用GCD搭建的基于UDP/IP协议的socket网络库。

这里我们只用到`GCDAsyncSocket`，因此只需要将`GCDAsyncSocket.h`和`GCDAsyncSocket.m`两个文件导入项目。

**注意：手机和打印机必须在同一局域网下，设置到打印机的host和port。**

### 步骤

#### 1、遵循`GCDAsyncSocketDelegate`协议

```objectivec
@interface MNSocketManager()<GCDAsyncSocketDelegate>
```

#### 2、声明属性

```objectivec
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
```

#### 3、初始化`GCDAsyncSocket`对象

```objectivec
self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
```

#### 4、连接打印机

```objectivec
NSError *error = nil;
[self.asyncSocket connectToHost:host onPort:port withTimeout:timeout error:&error];
```

连接成功后会通过代理回调

```css
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
}
```

#### 5、发送数据给打印机

Timeout为负，表示不设置超时时间。这里的data就是[上一篇](https://link.jianshu.com?t=https%3A%2F%2Fzhaomengnan.top%2F2017%2F12%2F19%2FiOS%E5%BC%80%E5%8F%91%E4%B9%8B%E8%93%9D%E7%89%99%E5%B0%8F%E7%A5%A8%E6%89%93%E5%8D%B0%E6%9C%BA(%E4%B8%80)%2F)中拼接的打印数据。

```csharp
[self.asyncSocket writeData:data withTimeout:-1 tag:0];
```

写入完成后回调

```objectivec
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"写入完成");
}
```

#### 6、断开连接

断开连接有以下几种方法

```csharp
[self.asyncSocket disconnect];
[self.asyncSocket disconnectAfterReading];
[self.asyncSocket disconnectAfterWriting];
[self.asyncSocket disconnectAfterReadingAndWriting];
```

连接断开后回调

```objectivec
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"连接断开");

}
```

#### 7、读取数据

读取到数据会回调

```objectivec
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"读取完成");
}
```

网口打印机一般都支持状态查询，查询指令如下：

![1612722-ed226356f1051101](https://gitee.com/coderiding/picbed/raw/master/uPic/1612722-ed226356f1051101.jpg)

打印机状态查询指令

可以通过[上一篇](https://link.jianshu.com?t=https%3A%2F%2Fzhaomengnan.top%2F2017%2F12%2F19%2FiOS%E5%BC%80%E5%8F%91%E4%B9%8B%E8%93%9D%E7%89%99%E5%B0%8F%E7%A5%A8%E6%89%93%E5%8D%B0%E6%9C%BA(%E4%B8%80)%2F)介绍指令拼接方法，查询打印机的状态。

## 总结

本篇只是简单介绍了，通过蓝牙和Socket连接打印机的方法。虽然可以初步完成连接和打印，但是，在真正的项目中使用还是远远不够的。这里还有很多情况需要考虑，比如连接断开、打印机异常、打印机缓冲区满、打印机缺纸等。我们可以针对自身的业务情况，进行相应的处理。

## 参考

[Core Bluetooth Programming Guide](https://link.jianshu.com?t=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Fdocumentation%2FNetworkingInternetWeb%2FConceptual%2FCoreBluetooth_concepts%2FAboutCoreBluetooth%2FIntroduction.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40013257-CH1-SW1)

[Getting the pixel data from a CGImage object](https://link.jianshu.com?t=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Fqa%2Fqa1509%2F_index.html)

[Core Bluetooth Programming Guide](https://link.jianshu.com?t=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Fdocumentation%2FNetworkingInternetWeb%2FConceptual%2FCoreBluetooth_concepts%2FAboutCoreBluetooth%2FIntroduction.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40013257%3Flanguage%3Dobjc)