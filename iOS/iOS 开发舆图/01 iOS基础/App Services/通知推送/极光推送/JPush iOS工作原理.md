![e9sMOx](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/e9sMOx.png)

从上图可以看出，JPush iOS Push 包括 2 个部分，APNs 推送（代理），与 JPush 应用内消息。

红色部分是 APNs 推送，JPush 代理开发者的应用（需要基于开发者提供的应用证书），向苹果 APNs 服务器推送。由 APNs Server 推送到 iOS 设备上。

蓝色部分是 JPush 应用内推送部分，即 App 启动时，内嵌的 JPush SDK 会开启长连接到 JPush Server，从而 JPush Server 可以推送消息到 App 里。

### APNs 通知
APNs 通知：是指通过向 Apple APNs 服务器发送通知，到达 iOS 设备，由 iOS 系统提供展现的推送。用户可以通过 IOS 系统的 “设置” >> “通知” 进行设置，开启或者关闭某一个 App 的推送能力。

JPush iOS SDK 不负责 APNs 通知的展现，只是向 JPush 服务器端上传 Device Token 信息，JPush 服务器端代理开发者向 Apple APNs 推送通知。