https://www.coder.work/article/7439862


flutter - 从Flutter中的 Isolate 监听方法调用UI方法会引发異常

flutter_downloader

https://app.yinxiang.com/shard/s35/nl/9757212/e11a2f96-9509-4c23-9e61-eb20a081f9ec


```DART
//發送download的進度
final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);

//監聽download進度數據
IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen(_updateDownLoadInfo);

//移除監聽
IsolateNameServer.removePortNameMapping('downloader_send_port');


