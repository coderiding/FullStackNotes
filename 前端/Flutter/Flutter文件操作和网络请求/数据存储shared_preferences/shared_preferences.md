```YAML
dependencies:
  shared_preferences: ^0.4.2
```


此插件在 iOS 上使用 NSUserDefaults，在 Android 上使用 SharedPreferences，为简单数据提供持久存储。

shared_preferences 实例常用方法：

get/setInt(key) - 查询或设置整型键。
get/setBool(key) - 查询或设置布尔键。
get/setDouble(key) - 查询或设置浮点键。
get/setString(key) - 查询或设置字符串键。
get/setStringList(key) - 查询或设置字符串列表键。
getKeys() - 获取所有键值名。
remove(key) - 删除某个键内容。
clear() - 清除全部内容。

参考

https://www.jianshu.com/p/fa739667242a  https://app.yinxiang.com/shard/s35/nl/9757212/2f11ecdd-af71-44ae-a58b-0c798a1975a0 