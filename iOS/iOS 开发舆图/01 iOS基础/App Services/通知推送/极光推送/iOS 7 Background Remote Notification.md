本次iOS 7在推送方面最大的变化就是允许，应用收到通知后在后台（background）状态下运行一段代码，可用于从服务器获取内容更新。功能使用场景：（多媒体）聊天，Email更新，基于通知的订阅内容同步等功能，提升了终端用户的体验。

Remote Notifications 与之前版本的对比可以参考下面两张 Apple 官方的图片便可一目了然。

![zUQ42h](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/zUQ42h.png)

![9VXeaU](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/9VXeaU.png)

如果只携带content-available: 1 不携带任何badge，sound 和消息内容等参数，则可以不打扰用户的情况下进行内容更新等操作即为“Silent Remote Notifications”。

![X5O8IH](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/X5O8IH.png)

### 客户端设置
开启Remote notifications
需要在Xcode 中修改应用的 Capabilities 开启Remote notifications，请参考下图：

![bJJn7S](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/bJJn7S.png)

#### 修改通知处理函数
当注册了Backgroud Modes -> Remote notifications 后，notification 处理函数一律切换到下面函数，后台推送代码也在此函数中调用。

```
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler；
```

### 服务端推送设置
推送消息携带 content-available: 1 是Background 运行的必须参数，如果不携带此字段则与iOS7 之前版本的普通推送一样。

#### 使用Web Portal 推送
在“可选设置内”选择对应的参数。

![IBSh9l](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/IBSh9l.png)

#### 使用 API 推送
只需在Push API v3 的 ios 内附加content-available":true 字段即可

### 限制与注意
“Silent Remote Notifications”是在 Apple 的限制下有一定的频率控制，但具体频率不详。所以并不是所有的 “Silent Remote Notifications” 都能按照预期到达客户端触发函数。
“Background”下提供给应用的运行时间窗是有限制的，如果需要下载较大的文件请参考 Apple 的 NSURLSession 的介绍。
“Background Remote Notification” 的前提是要求客户端处于Background 或 Suspended 状态，如果用户通过 App Switcher 将应用从后台 Kill 掉应用将不会唤醒应用处理 background 代码。
更详细的说明资料请查阅 Apple 官方的 iOS 开发文档。