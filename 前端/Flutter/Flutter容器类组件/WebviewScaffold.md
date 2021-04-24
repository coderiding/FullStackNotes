WebviewScaffold是插件提供的组件，用于在页面上显示一个WebView并加载URL

如果想要监听Web的状态,就需要用到FlutterWebviewPlugin来设置监听.可以完成native和h5混合开发。

```dart
Key key,
 this.appBar,
 @required this.url,//String 加载的URL
 this.headers,//添加头部
 this.withJavascript,//bool 是否开启Javascript
 this.clearCache,//bool 清理缓存
 this.clearCookies,//bool 清理cookies
 this.enableAppScheme,//
 this.userAgent,//String userAgent
 this.primary = true,
 this.persistentFooterButtons,
 this.bottomNavigationBar,//Widget 底部的bar
 this.withZoom,//bool 是否允许缩放
 this.withLocalStorage,//bool 是否开启本地缓存
 this.withLocalUrl,//bool
 this.scrollBar,//bool 是否显示scrollBar
 this.supportMultipleWindows,
 this.appCacheEnabled,//bool 是否开启缓存
 this.hidden = false,//bool 是否隐藏
 this.initialChild,//初始化的child,如果hidden = true 显示Widget
 this.allowFileURLs,//bool 是否允许请求本地的FileURL
 this.resizeToAvoidBottomInset = false,
 this.invalidUrlRegex,
 this.geolocationEnabled
```

参考
https://blog.csdn.net/sinat_17775997/article/details/95003479  https://app.yinxiang.com/shard/s35/nl/9757212/30eff73c-0c56-4e40-803a-0486f90caa85