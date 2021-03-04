### iOS 9 变动影响 SDK 部分:

增加了 bitCode 编码格式，当 SDK 不支持 bitCode 时，用户集成时无法开启 bitCode 选项。
现象：用户集成 SDK 后无法编译通过，错误日志里包含了 bitCode 的相关错误信息
默认使用 https 连接，如果请求为 http，需要手动配置 plist 来支持 http 服务，当前我们的服务器请求都走 http 服务。
现象：用户集成 SDK 后，所有 JPush 相关的 http 服务都提示连接错误或者连接超时，可能是此问题。

### bitCode 解决方式

JPush iOS SDK v1.8.7 及以上版本的SDK,已经增加对 iOS 9 新特性 bitCode 的支持。JMessage iOS SDK v2.0.0 及以上版本支持 bitCode。

### Https 解决方式

SDK 未提供 https 地址版本时

需要用户主动在当前项目的 Info.plist 中添加 NSAppTransportSecurity 类型 Dictionary。
在 NSAppTransportSecurity 下添加 NSAllowsArbitraryLoads 类型 Boolean，值设为 YES