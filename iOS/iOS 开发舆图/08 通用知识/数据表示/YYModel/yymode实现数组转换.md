## yymode实现数组转换

```
协议modelContainerPropertyGenericClass数组类型转要实现

如果Student中存在property是对象数组或者字典，实现modelContainerPropertyGenericClass方法，例如Student存在属性mobilePhones，维护一组MobilePhone对象

@interface MobilePhone : NSObject
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, assign) NSInteger phoneNumber;
@end
  
@interface Student : NSObject <YYModel>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) College *college;
@property (nonatomic, strong) NSArray *mobilePhones; //MobilePhone对象数组
@end
NSDictionary *studentDic = 
  @{@"name" : @"Tomy",
    @"age" : @18,
    @"college" : @{@"name" : @"NJU"},
    @"mobilePhones" : @[@{@"brand" : @"iphone",@"phoneNumber" : @123456},
                        @{@"brand" : @"HUAWEI",@"phoneNumber" : @123456}]};


调用[Student yy_modelWithDictionary:studentDic]方法将studentDic中的mobilePhones转化成Student的mobilePhones属性，需要实现如下：

+ (nullable NSDictionary<NSString*, id>*)modelContainerPropertyGenericClass
{
    return @{@"mobilePhones" : [MobilePhone class]};
}
```