---
title: Core Bluetooth - Background Procesing
tags:
  - 蓝牙
  - 后台运行
categories: 蓝牙
abbrlink: 25243
date: 2016-06-14 12:01:03
---

## 0x00 - 前言

对于蓝牙来说，如果不设置相关的后台运行许可，那么在程序退到后台的时候是系统是不允许做蓝牙的相关操作的。

## 0x01 - Foreground-Only Apps

有一些应用只允许在前台使用，对于这种应用的话，蓝牙的就不需要设置后台运行权限。在应用退到后台的时候，系统提供了蓝牙断开/连接的弹窗提醒。不至于蓝牙断开了用户都一点都不知道。

`CBCentralManager`在调用`connectPeripheral:options:`的时候，option 可以设置为一下几种：

- CBConnectPeripheralOptionNotifyOnConnectionKey 蓝牙连接的时候弹窗提醒
- CBConnectPeripheralOptionNotifyOnDisconnectionKey 蓝牙断开的时候弹窗提醒
- CBConnectPeripheralOptionNotifyOnNotificationKey 接到任何通知的时候弹窗提醒

<!-- more -->

## 0x02 - 后台模式

`Info.plist` 添加 `UIBackgroundModes` key，值为`bluetooth-central`或者`bluetooth-peripheral`，看场景区分使用

对于一些需要常驻后台的app，系统提供了保存和恢复现场的方式让你的app“常驻”。具体需要实现以下4步：（前3步require，后1步option）

**1、Opt In to State Preservation and Restoration**
初始化`CBCentralManager`或者`CBPeripheralManager`实例的时候指定 option key `CBCentralManagerOptionRestoreIdentifierKey`。例如：

```
myCentralManager =
        [[CBCentralManager alloc] initWithDelegate:self queue:nil
         options:@{ CBCentralManagerOptionRestoreIdentifierKey:
         @"myCentralManagerIdentifier" }];
```

**Note:** 因为`CBCentralManager` 和 `CBPeripheralManager`可以有多个，在指定 option key 的时候需要确保 key 的唯一性。

**2、Reinstantiate Your Central and Peripheral Managers**
当你的App在后台被系统重新启动的时候，需要重新去初始化central和peripheral。这就需要你第一步指定的`CBCentralManagerOptionRestoreIdentifierKey`去初始化。如果你只有一个central和一个peripheral的话，这一步系统会帮你做好了，你无需关心。

如果你有多个central和peripheral的话，这就需要你自己选择相应的`CBCentralManagerOptionRestoreIdentifierKey`去重新初始化central和peripheral。

具体如下，系统在重新启动你的app的时候会调用`application: didFinishLaunchingWithOptions:`，在这函数里面可以通过`launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey]`拿到所有的 IdentifierKey ，然后就可以去 Reinstantiate 了。

```
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    NSArray *centralManagerIdentifiers =
        launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    ...
```

**3、Implement the Appropriate Restoration Delegate Method**

central 需要实现`centralManager:willRestoreState:` delegate
peripheral 需要实现`peripheralManager:willRestoreState:`

example:

```
- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)state {
 
    NSArray *peripherals =
        state[CBCentralManagerRestoredStatePeripheralsKey];
    ...
```

**4、 Update Your Initialization Process**

这一步主要是为了让你了解到重新初始进程是否顺畅，是否从之前中断的地方重新开始了~

例如，当在`centralManagerDidUpdateState:` 中初始化你的app的时候，你可以通过以下代码确定是否成功恢复到退出之前 peripheral 查找指定service的场景。

```
NSUInteger serviceUUIDIndex =
        [peripheral.services indexOfObjectPassingTest:^BOOL(CBService *obj,
        NSUInteger index, BOOL *stop) {
            return [obj.UUID isEqual:myServiceUUIDString];
        }];
 
    if (serviceUUIDIndex == NSNotFound) {
        [peripheral discoverServices:@[myServiceUUIDString]];
        ...
```

正如以上代码所展示的，如果系统在你查找服务的时候终止了你的程序。在调用`discoverServices:`探索存储的peripheral数据之前，如果你的app成功查找到了service，你就可以去检查是否有合适的 characteristics被查找到了，这样你就可以知道自己是否在正确的时间调用了正确的方法了。

参考：

[Core Bluetooth Background Processing for iOS Apps](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html#//apple_ref/doc/uid/TP40013257-CH7-SW1)