NSString+YTH.h
/**
 未知类型（仅限字典/数组/字符串）
 
 @param object 字典/数组/字符串
 @return 字符串
 */
+(NSString *) jsonStringWithObject:(id) object;

/**
 字典类型转JSON

 @param dictionary 字典数据
 @return 返回字符串
 */
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;


/**
 数组类型转JSON

 @param array 数组类型
 @return 返回字符串
 */
+(NSString *) jsonStringWithArray:(NSArray *)array;


/**
 字符串类型转JSON

 @param string 字符串类型
 @return 返回字符串
 */
+(NSString *) jsonStringWithString:(NSString *) string;

NSString+YTH.h
/**
 未知类型（仅限字典/数组/字符串）
 
 @param object 字典/数组/字符串
 @return 字符串
 */
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

/**
 字符串类型转JSON

 @param string 字符串类型
 @return 返回字符串
 */
+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"%@",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}

/**
 数组类型转JSON

 @param array 数组类型
 @return 返回字符串
 */
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

/**
 字典类型转JSON

 @param dictionary 字典数据
 @return 返回字符串
 */
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
   NSError *parseError = nil;

NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];

return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
 