### RegistrationID 定义
集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。

应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知

#### API - registrationIDCompletionHandler:(with block)

#### 支持的版本
开始支持的版本：2.1.9。

#### 接口定义
```
+ (void)registrationIDCompletionHandler:(void(^)(int resCode,NSString *registrationID))completionHandler;
```

#### 参数说明
(void(^)(int resCode,NSString *registrationID))completionHandler
* completionHandler 用于处理设置返回结果
* resCode 返回的结果状态码
* registrationID 返回 registrationID

```
[JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
    NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
}];
```

温馨提示：
建议使用此接口获取 registrationID，模拟器中调用此接口 resCode 返回 1011，registrationID 返回 nil。

### API - registrationID

* 调用此 API 来取得应用程序对应的 RegistrationID。 只有当应用程序成功注册到 JPush 的服务器时才返回对应的值，否则返回空字符串。

* 支持的版本
* 开始支持的版本：1.7.0。

* 接口定义
* +(NSString *)registrationID

温馨提示：
iOS 9 系统，应用卸载重装，APNs 返回的 devicetoken 会发生变化，开发者需要获取设备最新的 Registration id。请在 kJPFNetworkDidLoginNotification 的实现方法里面调用 "RegistrationID" 这个接口来获取 RegistrationID。

### 附加说明
* 通过 RegistrationID 推送消息和通知
可以通过 RegistrationID 来推送消息和通知， 参考文档 Push API v3， 当 audience 参数为 RegistrationID 时候即可根据 RegistrationID 推送。

注：要使用此功能，客户端 App 一定要集成有 r1.7.0 及以上版本的 JPush iOS SDK