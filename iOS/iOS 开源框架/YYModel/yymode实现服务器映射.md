## yymode实现服务器映射
```
协议modelCustomPropertyMapper 映射
modelCustomPropertyMapper方法，可以指定json和model转化过程中key的映射关系，如果存在以下的字典：
NSDictionary *studentDic = @{@"NAME" : @"Tomy",
                               @"AGE" : @{@"num":@18},
                             @"college" : @{@"name" : @"NJU"}};

如果需要将studentDic转化成Student类型的model，需要实现如下modelCustomPropertyMapper方法：

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
  return @{@"name" : @"NAME",
                 @"age" : @"AGE.num"};
}
```