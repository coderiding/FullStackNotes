#### iOS 9变动影响SDK部分:
增加了bitCode编码格式,当SDK不支持bitCode时，用户集成时无法开启bitCode选项.
现象:用户集成SDK后无法编译通过，错误日志里包含了bitCode的相关错误信息
默认使用https连接,如果请求为http,需要手动配置plist来支持http服务，当前我们的服务器请求都走http服务。
现象:用户集成SDK后，所有JPush相关的http服务都提示连接错误或者连接超时,可能是此问题。

#### bitCode解决方式
JPush iOS SDK v1.8.7 及以上版本的SDK,已经增加对 iOS 9 新特性 bitCode 的支持.JMessage iOS SDK v2.0.0 及以上版本支持bitCode。

#### Https解决方式
JPush 2.1.9及以上的版本则不需要配置此步骤

需要用户主动在当前项目的Info.plist中添加NSAppTransportSecurity类型Dictionary。
在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES