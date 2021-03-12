## 判断条件返回model类型
* modelCustomClassForDictionary方法用于指定生成Model的类型，如果没有实现该方法，用默认的类型，例如Student实现modelCustomClassForDictionary，如下：

```
+ (Class)modelCustomClassForDictionary:(NSDictionary*)dictionary {
  if ([dictionary[@"name"] isEqualToString @"Graduated"]) {
      return [Graduated class];
      } else {
      return [self class];
      }
}
```

* 调用[Student yy_modelWithDictionary:studentDic]方法，如果studentDic[@"name"]等于@"Graduated"，则不创建Student类型的对象，而是创建Graduated类型的对象。