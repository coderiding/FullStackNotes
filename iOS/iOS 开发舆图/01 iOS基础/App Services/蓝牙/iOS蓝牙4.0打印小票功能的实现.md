---
title: iOS蓝牙4.0打印小票功能的实现
tags: 蓝牙
categories: 蓝牙
abbrlink: 18112
date: 2016-06-19 12:01:03
---

公司业务有涉及到订单模块，客户需要连接蓝牙打印机打印订单小票。所以本文就记录一下iOS蓝牙打印的相关知识以及实际开发中遇到的问题解决方案。

### 1.前言

> 如果需要手机连接蓝牙设备就有两种方案：1.蓝牙设备生产厂商通过MFi认证（蓝牙软件开发者使用苹果标准的Bluetooth profiles可以不用申请MFi开发认证）。2.蓝牙芯片升级支持Bluetooth4.0（BLE)协议
>
> ![Xnip2020-11-05_18-05-36](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-05-36.jpg)
>
> image.png

以下内容只适合蓝牙4.0，如我们碰到过客户设备蓝牙版本是2.0的情况，咨询生厂厂家技术支持后得到这样的回复。

![Xnip2020-11-05_18-06-05](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-06-05.jpg)

咨询问题.png

![Xnip2020-11-05_18-06-54](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-06-54.jpg)

官方回复.png



<!-- more -->

### 2. 蓝牙基础知识

![Xnip2020-11-05_18-07-14](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-07-14.jpg)

两种模式.png

两组API分别对应不同的业务场景：
 （1）左侧的是“中心模式”，就是以你的APP作为中心，连接其他的外设；中心模式也是本文使用的模式。
 （2）右侧的是“外设模式”，使用手机作为外设识别其他中心设备操作的场景。
 每个蓝牙4.0的设备都是通过服务和特征来展示自己的，一个设备包含一个或多个服务，每个服务下面又包含若干个特征。特征是与外界交互的最小单位。

下图展示的是蓝牙打印中心模式的整体流程。

![Xnip2020-11-05_18-07-30](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-07-30.jpg)

### 3.蓝牙打印开发步骤

#### 3.1 建立蓝牙管理中心角色

创建Central管理器时，管理器对象会调用代理对象的centralManagerDidUpdateState:方法，需要实现这个方法来确保本地设备支持BLE（CBCentralManagerDelegate）

```objectivec
#pragma  mark -CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString * state = nil;
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
        {
            state = @"work";
            [self startDeviceDiscovery];
            break;
        }
        case CBCentralManagerStateUnknown:
        default:
            ;
    }
    NSLog(@"Central manager state: %@", state);
}
```

#### 3.2  搜索可用的蓝牙设备外设

调用CBCentralManager的scanForPeripheralsWithServices方法来扫描周围正在发出广播的外设。每找到一个外设会调centralManager:didDiscoverPeripheral:advertisementData:RSSI: 方法。该方法会CBPeripheral返回找到的外设，所以可以使用数组将找到的外设保存。

```objectivec
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral)
    {
        NSLog(@"foundDevice. name[%s],RSSI[%d]\n",peripheral.name.UTF8String,peripheral.RSSI.intValue);
        {
            //self.peripheral = peripheral;
            //发现设备后即可连接该设备 调用完该方法后会调用代理CBCentralManagerDelegate的- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral表示连接上了设别
            //如果不能连接会调用 - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
            //[centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey : YES}];
            if (![self.deviceList containsObject:peripheral])
                [self.deviceList  addObject:peripheral];
            
            [_reDiscoveryView removeFromSuperview];
            
            [self.deviceListTableView reloadData];
        }
    }
}
```

### 3.3连接蓝牙外设

当连接成功后，会回调方法centralManager:didConnectPeripheral:。在这个方法中，可以去记录当前的连接状态等数据。

```objectivec
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"has connected");
    peripheral.delegate = self;
    [[CentralManager sharedInstance].connectedDeviceArr addObject:peripheral];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.deviceList indexOfObject:peripheral] inSection:0];
    BluetoothDeviceCell * cell = [self.deviceListTableView cellForRowAtIndexPath:indexPath];
    cell.connectedStatus = YES;
    
    //此时设备已经连接上了找到该设备上的指定服务 调用完该方法后会调用代理CBPeripheralDelegate（现在开始调用另一个代理的方法了）的
    //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    
    for (CBPeripheral *aPeripheral in [CentralManager sharedInstance].connectedDeviceArr) {
        [aPeripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
        
        [aPeripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID_cj]]];
    }
}
```

如果连接失败，则会调用：

```objectivec
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //连接发生错误
    NSLog(@"connected periphheral failed");
}
```

#### 3.4扫描外设服务和特征

![Xnip2020-11-05_18-08-14](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-08-14.jpg)



当与外设成功建立连接以后，就可以通信了。第一步是先找到当前外设提供的 service。调用CBPeripheralDelegatel的discoverServices:方法可以找到当前外设的所有 service。

```csharp
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error==nil)
    {
        //在这个方法中要查找到需要的服务  然后调用discoverCharacteristics方法查找需要的特性
        //该discoverCharacteristics方法调用完后会调用代理CBPeripheralDelegate的
        //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        for (CBService *service in peripheral.services)
        {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
            {
                [CentralManager sharedInstance].cjFlag=0;
                //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
                [peripheral discoverCharacteristics:nil forService:service];
            }
            else if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID_cj]])
            {
                //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
                [CentralManager sharedInstance].cjFlag=1;
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}
```

在上面的方法中查找到需要的服务，然后调用discoverCharacteristics方法查找需要的特性:

```objectivec
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service;
```

上述方法调用完后会调用代理方法didDiscoverCharacteristicsForService

```csharp
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error==nil) {
        //在这个方法中要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
        //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]])
            {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                [CentralManager sharedInstance].activeWriteCharacteristic = characteristic;
            }
            else
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kReadCharacteristicUUID]])
                {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [CentralManager sharedInstance].activeReadCharacteristic = characteristic;
                }
                else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kFlowControlCharacteristicUUID]]) {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [CentralManager sharedInstance].activeFlowControlCharacteristic = characteristic;
                    [CentralManager sharedInstance].credit = 0;
                    [CentralManager sharedInstance].response = 1;
                }
                else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID_cj]]) {
                    
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [CentralManager sharedInstance].activeWriteCharacteristic = characteristic;
                }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kReadCharacteristicUUID_cj]]) {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [CentralManager sharedInstance].activeReadCharacteristic = characteristic;
                }
            [self.deviceListTableView reloadData];
            [self.scanConnectActivityInd stopAnimating];
            self.tempActiveDevice = peripheral;
        }
    }
}
```

#### 3.5 与外设进行数据交互

1）read方法时，回调updataValue；nofify时，notification回调一次后，updataValue再开始调，且不只一次；
 2）接收 characteristic 数据的方式有两种：
 在需要接收数据的时候，调用 readValueForCharacteristic:，这种是需要主动去接收的。
 用 setNotifyValue:forCharacteristic: 方法订阅，当有数据发送时，可以直接在回调中接收。
 向 characteristic 写数据
 写数据其实是一个很常见的需求，如果 characteristic 可写，你可以通过CBPeripheral类的writeValue:forCharacteristic:type:方法来向设备写入NSData数据。

```objectivec
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error==nil) {
        //在这个方法中要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
        //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
         ......
}
```

```css
 [[CentralManager sharedInstance].activeDevice writeValue:[NSData dataWithBytes:buf length:l] forCharacteristic:[CentralManager sharedInstance].activeWriteCharacteristic type:CBCharacteristicWriteWithResponse];
```

#### 3.6 断开连接

首先调用CBCentralManager的cancelPeripheralConnection方法去断开连接

```cpp
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;
```

如果成功断开连接，调用didDisconnectPeripheral方法

```objectivec
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    
    [[CentralManager sharedInstance].connectedDeviceArr removeObject:peripheral];
    
    if ([[CentralManager sharedInstance].selectedDeviceList containsObject:peripheral]) {
        [[CentralManager sharedInstance].selectedDeviceList removeObject:peripheral];
    }
    
    [self.deviceListTableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.deviceList indexOfObject:peripheral] inSection:0];
    BluetoothDeviceCell * cell = [self.deviceListTableView cellForRowAtIndexPath:indexPath];
    cell.connectedStatus = NO;
//    [self selectPrintDevice:cell];
}
```