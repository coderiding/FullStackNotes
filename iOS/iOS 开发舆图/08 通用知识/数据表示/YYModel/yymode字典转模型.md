## yymode字典转模型
```
yy_modelWithDictionary
yy_modelToJSONString

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) uint64_t pages;
@property (nonatomic, strong) NSDate *publishDate;

执行代码：
 NSDictionary *dic = @{
                          @"name": @"Harry Potter",
                          @"pages": @(512),
                          @"publishDate": @"2010-01-01"
                          };
YYBook *book1 = [YYBook yy_modelWithDictionary:dic];
NSString *bookJSON1 = [book1 yy_modelToJSONString];
NSLog(@"bookJSON: %@",bookJSON1);

---

json to yymodel
yy_modelWithJSON
yy_modelToJSONObject
// JSON:
{
    "uid":123456,
    "name":"Harry",
    "created":"1965-07-31T00:00:00+0000"
}

// Model:
@interface User : NSObject
@property UInt64 uid;
@property NSString *name;
@property NSDate *created;
@end

@implementation User

@end

---

// 将 JSON (NSData,NSString,NSDictionary) 转换为 Model:
User *user = [User yy_modelWithJSON:json];

// 将 Model 转换为 JSON 对象:
NSDictionary *json = [user yy_modelToJSONObject];
```