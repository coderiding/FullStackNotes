https://dart.dev/null-safety/migration-guide

在项目输入 

```dart
dart migrate
```

### 将插件包升级到有空安全的合适版本

```yaml
dart pub upgrade --null-safety

```

### 获取依赖项的迁移状态

* 可以通过下面的命令检查最新版本是否支持 null safety

dart pub outdated --mode=null-safety

### 不迁移的解决方法

* 在所有之前的命令上加上  --no-sound-null-safety

flutter run --no-sound-null-safety

flutter build apk --no-sound-null-safety