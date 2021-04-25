https://pub.dev/packages/connectivity

该插件允许Flutter应用发现网络连接并进行相应配置。它可以区分蜂窝连接和WiFi连接。该插件适用于iOS和Android。

```DART
//pubspec.yaml 添加依赖
dependencies:
  connectivity: ^3.0.3

import 'package:connectivity/connectivity.dart';

var connectivityResult = await (Connectivity().checkConnectivity());
if (connectivityResult == ConnectivityResult.mobile) {
  // I am connected to a mobile network.
} else if (connectivityResult == ConnectivityResult.wifi) {
  // I am connected to a wifi network.
}
```