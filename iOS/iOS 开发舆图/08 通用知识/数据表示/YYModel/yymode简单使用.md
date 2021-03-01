# yymode简单使用

* https://github.com/ibireme/YYModel

```

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

	
// Convert json to model:
User *user = [User yy_modelWithJSON:json];
	
// Convert model to json:
NSDictionary *json = [user yy_modelToJSONObject];

```