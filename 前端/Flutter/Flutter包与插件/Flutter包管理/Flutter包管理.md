https://book.flutterchina.club/chapter2/flutter_package_mgr.html#pub%E4%BB%93%E5%BA%93

pubspec.yaml

```YAML
name: flutter_in_action
description: First Flutter application.

version: 1.0.0+1

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^0.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
    
flutter:
  uses-material-design: true
```
* name：应用或包名称。

* description: 应用或包的描述、简介。

* version：应用或包的版本号。

* dependencies：应用或包依赖的其它包或插件。

* dev_dependencies：开发环境依赖的工具包（而不是flutter应用本身依赖的包）。

* flutter：flutter相关的配置选项。
