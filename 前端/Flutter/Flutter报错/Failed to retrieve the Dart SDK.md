Failed to retrieve the Dart SDK from: https://storage.googleapis.com/flutter_infra/flutter/b09f014e9658da6647361e7e416d1a159d34192d/dart-sdk-darwin-x64.zip

If you're located in China, please see this page:
  https://flutter.dev/community/china


总结：就是配置国内的镜像点，然后在国内可以下载需要的sdk，看你选择哪个镜像点，有3个，我选了flutter中文社区的如下。

需要在运行命令之前设置两个环境变量PUB_HOSTED_URL和 FLUTTER_STORAGE_BASE_URLflutter

export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

---
参考
https://www.tizi365.com/archives/218.html   https://app.yinxiang.com/shard/s35/nl/9757212/9e738134-ca3c-4f7e-bc8b-8cb162f996a1

