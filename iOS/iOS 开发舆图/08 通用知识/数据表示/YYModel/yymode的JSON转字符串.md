## yymode的JSON转字符串
```
yy_modelToJSONString
yy_modelWithJSON
// JSON ->模型 （内部实现：json -> 字典 -> 模型）
YYBook *book = [YYBook yy_modelWithJSON:@"     \
                {                                           \
                \"name\": \"Harry Potter\",              \
                \"pages\": 512,                          \
                \"publishDate\": \"2010-01-01\"          \
                }"];
//模型 -> 字符串
NSString *bookJSON = [book yy_modelToJSONString];
NSLog(@"Book: %@", bookJSON);
```