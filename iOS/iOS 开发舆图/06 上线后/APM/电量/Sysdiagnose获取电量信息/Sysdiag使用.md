官网下载证书 Profiles and Logs。（需要开发者证书）
https://developer.apple.com/bug-reporting/profiles-and-logs/?platform=ios

下载完成后通过 AirDrop 发到测试手机上安装。

在不重启手机的情况下，等待10到30分钟。

手机连上电脑，通过 iTunes 同步到电脑上。

去 ~/Library/Logs/CrashReporter/MobileDevice 目录下，打开 powerlog_xxxx.PLSQL 文件。

我们可以看到，powerlog_xxxx.PLSQL 是个相当庞大的文件，里面有几百张表，所有的电量数据都在里面。主要的几张表的意思如下：



表名	内容

PLBatteryAgent_EventBackward_Battery	整台机器的电量数据，包含电流、电压、温度等，每 20 秒 左右一条数据

PLBatteryAgent_EventBackward_BatteryUI	电量百分比数据，每 20 秒一条数据

PLIOReportAgent_EventBackward_EneryModel	整机的详细电量数据。包含 CPU\GPU\DRAM\ISP 等关键信息。每半小时到一小时一条数据。

PLAccountingOperator_EventNone_Nodes	App 结点信息，每个 APP 对应唯一的结点号。用来确定手机内具体哪个 App。

PLApplicationAgent_EventForward_Application	App 运行信息，记录每个 App 在哪个时间段以什么状态运行

PLAppTimeService_Aggregate_AppRunTime	APP 的运行时长统计，每个运行过的 APP，一小时一条数据

PLAccountingOperator_Aggregate_RootNodeEnergy	APP 的电量详细数据，记录每个 APP 的CPU\GPU\DRAM\ISP 等的耗电信息。一小时更新一次数据。

作者：ifelseboyxx
链接：https://www.jianshu.com/p/e488ef221e51
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。