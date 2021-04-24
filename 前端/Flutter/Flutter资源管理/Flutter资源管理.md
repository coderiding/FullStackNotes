Flutter APP安装包中会包含代码和 assets（资源）两部分。Assets是会打包到程序安装包中的，可在运行时访问。常见类型的assets包括静态数据（例如JSON文件）、配置文件、图标和图片（JPEG，WebP，GIF，动画WebP / GIF，PNG，BMP和WBMP）等。

使用pubspec.yaml (opens new window)文件来管理应用程序所需的资源

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

asset的实际目录可以是任意文件夹（在本示例中是assets文件夹）。

在构建期间，Flutter将asset放置到称为 asset bundle 的特殊存档中，应用程序可以在运行时读取它们（但不能修改）。

# 变体

 在pubspec.yaml的assets部分中指定asset路径时，构建过程中，会在相邻子目录中查找具有相同名称的任何文件。这些文件随后会与指定的asset一起被包含在asset bundle中。

 例如，如果应用程序目录中有以下文件:

…/pubspec.yaml
…/graphics/my_icon.png
…/graphics/background.png
…/graphics/dark/background.png
…etc.

然后pubspec.yaml文件中只需包含:
```YAML
flutter:
  assets:
    - graphics/background.png
```
那么这两个graphics/background.png和graphics/dark/background.png 都将包含在您的asset bundle中。前者被认为是_main asset_ （主资源），后者被认为是一种变体（variant）。