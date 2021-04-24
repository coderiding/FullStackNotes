想打包某个包中的图片到你的代码中

如果在pubspec.yaml文件中声明了期望的资源，它将会打包到相应的package中。特别是，包本身使用的资源必须在pubspec.yaml中指定。

包也可以选择在其lib/文件夹中包含未在其pubspec.yaml文件中声明的资源。在这种情况下，对于要打包的图片，应用程序必须在pubspec.yaml中指定包含哪些图像。 例如，一个名为“fancy_backgrounds”的包，可能包含以下文件：

…/lib/backgrounds/background1.png
…/lib/backgrounds/background2.png
…/lib/backgrounds/background3.png
要包含第一张图像，必须在pubspec.yaml的assets部分中声明它：

lib/是隐含的，所以它不应该包含在资产路径中。

#

```yaml
flutter:
  assets:
    - packages/fancy_backgrounds/backgrounds/background1.png
```