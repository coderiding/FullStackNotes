程序运行的时候出现下面的错误信息：

did Fail To Register For Remote Notifications With Error: Error Domain=NSCocoaErrorDomain Code=3000 "未找到应用程序的“aps-environment”的权利字符串" UserInfo=0x1c55e000 {NSLocalizedDescription=未找到应用程序的“aps-environment”的权利字符串}

这个是由于你的 Provisioning Profile 文件，不具备 APNS 功能导致的。请登陆 Apple Developer 网站设置好证书，更新 Provisioning Profile，重新导入 Xcode。

或参考：http://blog.csdn.net/stefzeus/article/details/7418552