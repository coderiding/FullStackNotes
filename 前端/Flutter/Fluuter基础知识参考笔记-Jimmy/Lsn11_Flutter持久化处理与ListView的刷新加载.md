# Lsn11.Flutter持久化处理与ListView的刷新加载

[TOC]

## 文件存储--path_provider库

Flutter使用path_provider插件读取与写入文件，path_provider插件提供了一种平台无关的方法来访问设备文件系统上常用的位置。该类目前支持访问三个文件系统位置：  

1. 临时目录：系统可以随时清除的临时目录（缓存），在iOS上，对应NSTemporaryDirectory（）返回的值，在Android上，这是getCacheDir（）返回的值。  
2. 文档目录：应用程序的目录，用于存储只有它可以访问的文件，仅当删除应用程序时，系统才会清除目录，在iOS上，这对应NSDocumentsDirectory，在Android上，这是AppData目录。  
3. 外部存储设备。 -- iso直接报错

## Preferences存储--shared_preferences库

## 数据库--sqflite库

## ListView下拉刷新与上拉加载

下拉刷新控件：RefreshIndicator 

```
const RefreshIndicator({
    Key key,
    @required this.child,
    this.displacement = 40.0,//下拉展示距离
    @required this.onRefresh,//刷新回调
    this.color,//刷新进度颜色
    this.backgroundColor,//背景颜色
    this.notificationPredicate = defaultScrollNotificationPredicate,
  })
```

上拉加载通过ScrollController的addListener()监听

```
//判断listview是否滑动到了底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent)
```

