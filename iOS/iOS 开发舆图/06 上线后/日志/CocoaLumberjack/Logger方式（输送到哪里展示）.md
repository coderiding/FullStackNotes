1. DDLog（整个框架的基础）
2. DDASLLogger（发送日志语句到苹果的日志系统，以便它们显示在Console.app上）
    - 捕获 ASL 存储日志
    - 通过 CocoaLumberjack 这个第三方日志库里的DDASLLogCapture 这个类
    - notify_register_dispatch 的作用是用来注册进程间的系统通知。其中，kNotifyASLDBUpdate 宏表示的就是，日志被保存到 ASL 数据库时发出的跨进程通知，其键值是 com.apple.system.logger.message。
    - 类似地把日志保存到 ASL 数据库时发出的通知还有很多种，比如键值是com.apple.system.lowdiskspace 的 kNotifyVFSLowDiskSpace 宏，该通知是在系统磁盘空间不足时发出的。当捕获到这个通知时，你可以去清理缓存空间，避免发生缓存写入磁

    盘失败的情况。

3. DDOSLogger

    ```objectivec
    [DDLog addLogger： [DDOSLogger sharedInstance ]]; //使用os_log
    ```

4. DDTTYLoyger（发送日志语句到Xcode控制台）
5. DDFIleLoger（把日志写入本地文件）
    - 如果你需要汇总一段时间的调试日志的话，自己把这些日志写到一个文件里就好了。

    ```objectivec
    DDFileLogger * fileLogger = [[DDFileLogger alloc ] init ]; // File Logger 
    fileLogger.rollingFrequency = 60 * 60 * 24 ; // 24小时滚动
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7 ;
    [DDLog addLogger： fileLogger];
    ```

6. 你可以同时记录文件和控制台，还可以创建自己的logger，将日志语句发送到网络或者数据库中。比如使用这个

[s4nchez/LogIO-CocoaLumberjack](https://github.com/s4nchez/LogIO-CocoaLumberjack)