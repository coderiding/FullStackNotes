对象在运行时获取其类型的能力称为内省

运行时

获取类型

### 判断对象类型

```
-(BOOL) isKindOfClass:            判断是否是这个类或者这个类的子类的实例
-(BOOL) isMemberOfClass:      判断是否是这个类的实例
```

### 判断对象/类是否有这个方法

```
-(BOOL) respondsToSelector:                      判读实例是否有这个方法
+(BOOL) instancesRespondToSelector:      判断类是否有这个方法
```


参考

https://www.jianshu.com/p/5428c8742329  https://app.yinxiang.com/shard/s35/nl/9757212/aa715872-2660-458d-9d16-461bd9947bdd