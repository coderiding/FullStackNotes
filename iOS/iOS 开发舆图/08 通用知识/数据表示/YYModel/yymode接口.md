## yymode接口

```
+ (nullable instancetype)yy_modelWithJSON:(id)json;
+ (nullable instancetype)yy_modelWithDictionary:(NSDictionary *)dictionary;

- (nullable NSData *)yy_modelToJSONData;
- (nullable NSString *)yy_modelToJSONString;
- (nullable id)yy_modelCopy;

- (BOOL)yy_modelSetWithJSON:(id)json;
- (BOOL)yy_modelSetWithDictionary:(NSDictionary *)dic;
- (nullable id)yy_modelToJSONObject;

- (void)yy_modelEncodeWithCoder:(NSCoder *)aCoder;
- (id)yy_modelInitWithCoder:(NSCoder *)aDecoder;
- (NSUInteger)yy_modelHash;
- (BOOL)yy_modelIsEqual:(id)model;
- (NSString *)yy_modelDescription;


///针对后台最外层返回数组
+ (nullable NSArray *)yy_modelArrayWithClass:(Class)cls json:(id)json;
+ (nullable NSDictionary *)yy_modelDictionaryWithClass:(Class)cls json:(id)json;


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;
+ (nullable Class)modelCustomClassForDictionary:(NSDictionary *)dictionary;
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;
+ (nullable NSArray<NSString *> *)modelPropertyWhitelist;
```