---
title: ios蓝牙打印
tags: 蓝牙
categories: 蓝牙
abbrlink: 18115
date: 2016-06-21 12:01:03
---

**ps**:近来公司有个ios调用蓝牙打印机打印小票的功能，网上资料也有，ESC/POS打印指令集也有，以前刚毕业有做过winform调用网络小票打印机的功能，指令集反正都是差不多的。只是攻略不是很详细，这里把详细步骤和遇到的问题以及解决方法详细的记录下，已供后来人参考。这里建议大家还是使用ESC/POS指令来实现打印功能，大多数给力的打印机厂商都会兼容这套指令。
闲话不多说，经验教程如下：

**ps**:我使用的是swift开发

# 蓝牙连接

> 蓝牙框架引入

```
import CoreBluetooth
```

> 创建蓝牙管理类

```
lazy var blueManager:CBCentralManager? = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
```

> 扫描可连接蓝牙

```
blueManager?.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
```

> 蓝牙处理代理类

蓝牙设置开关的代理

<!-- more -->

```
func centralManagerDidUpdateState(central: CBCentralManager) {
    switch (central.state)
    {
    case CBCentralManagerState.PoweredOn:
        //当蓝牙打开时，自动扫描对应的外设
            blueManager?.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        }
        break
    default:
        NSLog("Central Manager did change state")
        break;
    }
}
```

扫描监听代理，当扫描到蓝牙设备时，这里会接受到通知

```
func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    let uuid = peripheral.identifier.UUIDString
            print("发现设备")
            print(uuid)
            print(peripheral.name, advertisementData)
    print("------------------------------------------")
    /**
    * 不包含服务功能
    */
    if advertisementData["kCBAdvDataServiceUUIDs"] == nil {
        return
    }
    //这里是把扫描到的不同设备保存起来，devices是自己定义的一个蓝牙设备数组
    if devices.find({$0.peripheral?.identifier.UUIDString == uuid}) == -1 {
        let serviceID = (advertisementData["kCBAdvDataServiceUUIDs"] as? (String,String))?.1 ?? ""
        devices.append(Device(name: peripheral.name ?? LS("unnamed"), peripheral: peripheral, serviceUUID:serviceID)) //"未命名"
    }
        
}
```

从打印机数组里面确定需要选择的打印机 调用连接代码，弱水三千，取一瓢而饮之。

```
func connectDevice(device:Device) {
    blueManager?.stopScan()
    currentDevice = device
    blueManager?.connectPeripheral(device.peripheral!, options: nil)
}
```

连接打印机后，系统继续调用代理，告诉你连接结果
顾名思义，连不上T0T

```
func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
    MessageShow.ShareInstance.errorMessage = error?.localizedFailureReason ?? ""
    printDelegate?.selectPrinter()
}
```

连上了~，~

```
func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
    noConnectedTimer?.invalidate()
    disConnectTimer?.invalidate()
    peripheral.delegate = self
    peripheral.discoverServices(nil)
}
```

这是分手(断开连接)后的通知

```
func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
}
```

连接上peripheral后需要连接对应的服务才能算真正连上

```
func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
    if error != nil {
        MessageShow.ShareInstance.errorMessage = error?.localizedFailureReason ?? LS("notfindprintservice") //"该设备找不到对应的打印服务"
        return
    }
    for service in peripheral.services! {
        //正常打印机的打印服务就是这个uuid
        if service.UUID == CBUUID(string: "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2") {
            currentDevice?.service = service
            //是的，你没看错，连上服务还得再连所谓的特性
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    if currentDevice?.service == nil {
        MessageShow.ShareInstance.errorMessage = LS("notfindprintservice") //"该设备找不到对应的打印服务"
        currentDevice = nil
    }
}

连接characteristics(翻译：特性)

func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
    if error != nil {
        MessageShow.ShareInstance.errorMessage = error?.localizedFailureReason ?? LS("notfindprintservice") //"该设备找不到对应的打印服务"
        return
    }

    if service.characteristics != nil {
        for characteristic in service.characteristics! {
            if characteristic.UUID == CBUUID(string: "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F") {
                currentDevice?.characteristic = characteristic
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                //打印机连上了，后面就可以对他发指令打印了
                //printDelegate?.doPrintBill()
            }
        }
    }
}
```

再来个断开连接的代码
`blueManager?.cancelPeripheralConnection(currentDevice!.peripheral!)`

# 打印机指令集

再开始打印指令的教程前，免不得先说说遇到坑吧。

1. ios对打印机的指令发送是必须要有长度限度的，不同打印机的长度不一样。当你发现打印一个长长的字符串发现打一半卡死时，就得考虑下长度截取的问题了。
2. 大多数打印机没有交互功能，也就是只能对牛弹琴了。so断开打印机的时机也是个问题。当然一对一永远连接的就不用断开了。
3. 打印条码，建议还是需要打印功能比较好的打印机。

下面大致写下常用的打印指令：

> 初始化打印机

```
func initPrint() {
    sendCode([0x1b, 0x40], boolEnd: true)
}
```

> 打印字符串

打印字符串的位置一般自己调吧，align表示这行（注意行，这个不能拆分）的打印靠左靠右

```
func printText(text: String, align: NSTextAlignment) {
    self.align(align)
    //中文字符打印需要转码
    let encode =  CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
    var printStr = text
    //兼容某些渣渣打印机设置长度限制，好点的打印机1000也没什么问题
    while printStr.charLength() > 60 {
        let nowStr = printStr.substringToIndex(32)
        let tmpData = NSString(string: nowStr).dataUsingEncoding(encode, allowLossyConversion: false)!
        sendMsg(tmpData)
        printStr = printStr.substringFromIndex(32)
    }
    if printStr.characters.count > 0 {
        let tmpData = NSString(string: printStr).dataUsingEncoding(encode, allowLossyConversion: false)!
        sendMsg(tmpData)
    }
}

/**
 text 对齐

 - parameter align: .
 */
func align(align:NSTextAlignment) -> NSMutableData {
    if align == currentAlign {
        return NSMutableData()
    }
    currentAlign = align
    var bytes:[UInt8] = [0x1b, 0x61]
    switch align {
    case .Center:
        bytes.append(0x01)
    case .Right:
        bytes.append(0x02)
    default:
        bytes.append(0x00)
    }
    sendCode(bytes)
    return NSMutableData()
}

//加粗

func bold(enable:Bool) {
    var bytes:[UInt8] = [0x1b, 0x45]
    bytes.append(enable ? 0x01 : 0x00)
    sendCode(bytes)
}

//打开钱箱    

func openBox() {
    let bytes:[UInt8] = [27,112, 0, 200,200]
    sendCode(bytes)
}

/**
 结束走纸 最后表示走几行纸
 */
func endPrint() {
    sendCode([0x1b, 0x64, 0x05] as [UInt8])
    cutPaper()
}

/**
 切纸
 */
func cutPaper() {
    //半切01，全切00
    sendCode([0x1d, 0x56, 0x00] as [UInt8], boolEnd: true)
}
```

> 打印图片

图片需要做点阵转换，这个代码太多，给个搬砖地址。[HLBluetoothDemo](https://github.com/Haley-Wong/HLBluetoothDemo)
，这里有点要注意下，改github的代码并不能在佳博打印机上打印二维码或者图片。主要是因为佳博打印机每次发送指令的最大长度只有146.而示例都是把指令全部组装好了一起发送，会导致打印机断片。

所以下面的代码就是把图片指令拆分长度来发送给打印机

```
   private func printImg(_ image: UIImage, width: CGFloat) {
        guard let borderImg = image.decorateBorder(10) else {
            return
        }
        if let img = borderImg.blackAndWhite()?.imageWithscaleMaxWidth(width) {
            if let data = img.bitmapData() {
                log.ln("qrcode size: " + data.count.description)/
                var curIndex = 0
                let step = 100
                while(curIndex < data.count) {
                    let endIndex = curIndex + step < data.count ? curIndex + step : data.count
                    let tmpData = data.subdata(in: curIndex..<endIndex)
                    peripheral?.writeValue(tmpData, for: characteristic!, type: .withoutResponse)
                    curIndex += step
                }
            }
        }
        
        printNewLine()
//        // 恢复行间距
        sendCode([0x1b, 0x32], boolEnd: true)
    }
```

上面代码里面有个***image.decorateBorder\***，这是因为指令拆分后不知道为什么图片打印最下面几行总会有缺失，无法找到原因，所以做了个特别的处理，先给图片加了个外框。那么缺失的就是边框了，不影响图片整体打印。

```
extension UIImage {
    func decorateBorder(_ borderWidth: CGFloat) -> UIImage? {
        let resultSize = CGSize(width: self.size.width + 2 * borderWidth, height: self.size.height + 2 * borderWidth)
        UIGraphicsBeginImageContext(resultSize)
        let borderPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: resultSize), cornerRadius: 0)
        UIColor.white.setFill()
        borderPath.fill()
        let imgRect = CGRect(x: borderWidth, y: borderWidth, width: self.size.width, height: self.size.height)
        self.draw(in: imgRect)
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg
    }
}
```

之所以要用***imageWithscaleMaxWidth\***，是因为二维码太宽导致图片大小太大，超出了打印机的缓存空间，会导致图片打印不出来。

最后推荐下指令集比较完整的文档：

http://www.docin.com/p-676248934.html