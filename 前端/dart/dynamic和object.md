### dynamic:（没有静态类型检查）- 少用

dynamic 关闭类型检查

所有dart 对象的基础类型，在大多数情况下，不直接使用它 通过它定义的变量会关闭类型检查，这意味着 dynamix x= ‘hal’; x.foo();这段静态类型检查不会报错，但是运行时会crash，因为x 并没有foo（） 方法，所以建议大家在编程时不要直接使用dynamic；

### var:

根据值自动判断类型

是一个关键字，意思是"我不关心这里的类型是什么"，系统会自动判断类型 runtimeType;

### object:（有静态类型检查）

是Dart 对象的基类，当你定义： object o =xxx ; 这个时候系统会认为o是个对象，你可以调用o的toString()和hashCode()方法因为Object 提供了这些方法，但是如果你尝试调用o.foo()时，静态类型检查会运行报错。综上不难看出dynamic 与object 的最大的区别是在静态类型检查上。

参考

https://blog.csdn.net/beyondforme/article/details/104109403  https://app.yinxiang.com/shard/s35/nl/9757212/10d999bb-f7de-47b8-8bd7-35399290b9b8