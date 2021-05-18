Flutter 与 Native 的通信是通过 Platform Channel 实现的，它是一种 C/S 模型，其中 Flutter 作为 Client，iOS 和 Android 平台作为 Host，Flutter 通过该机制向 Native 发送消息，Native 在收到消息后调用平台自身的 API 进行实现，然后将处理结果再返回给 Flutter 页面。

<img src='https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/2u2mdI.png' alt='2u2mdI'/>

<img src='https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/CoR4Ir.png' alt='CoR4Ir'/>

https://www.infoq.cn/article/XOk356QDtIlWHRZdGqaM?utm_source=rss&utm_medium=article


Native 平台在收到对方发来的消息后，meesager 会将消息内容分发给对应的 handler 进行处理，在处理完成后还可以通过回调方法 result 将处理结果返回给 Flutter。[message 将将收到的flutter消息，分给handle处理，最后把处理结果返回给flutter]

### Flutter 中的 Platform Channel 机制提供了三种交互方式：

BasicMessageChannel ：用于传递字符串和半结构化信息；

MethodChannel ：用于传递方法调用和处理回调；

EventChannel：用于数据流的监听与发送。

### 每种Channel都有的參數

String name「汶：每個channel的唯一標識符」

BinaryMessager messager「汶：中介管理者」

MessageCodec/MethodCodec codec
用于 Native 与 Flutter 通信过程中的编解码，在发送方能够将 Flutter（或 Native）的基础类型编码为二进制进行数据传输，在接收方 Native（或 Flutter）将二进制转换为 handler 能够识别的基础类型。「汶：傳輸的二進制數據」


https://mp.weixin.qq.com/s/mRXDKvyj_3pDjxM_axTDmQ   https://app.yinxiang.com/shard/s35/nl/9757212/4c3fdde3-27b2-439a-beb5-add2ac84d054