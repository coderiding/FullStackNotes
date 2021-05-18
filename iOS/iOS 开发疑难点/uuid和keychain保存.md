https://www.cnblogs.com/kekec/p/12560850.html

https://app.yinxiang.com/shard/s35/nl/9757212/66bb201b-5903-4b4f-9a3b-668c529235b7

https://blog.csdn.net/yangxuan0261/article/details/113801704    https://app.yinxiang.com/shard/s35/nl/9757212/ec00448a-ffd7-4ec3-a27d-39c53d14a910


https://github.com/baptistefetet/KeychainItemWrapper/blob/master/KeychainItemWrapper.h

最直接的代码

```

//
//  UUID.h
//
//  Created by lijianping on 2015/11/13.
//  Copyright (c) 2015年 com.sanfield.hyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUID : NSObject

+(NSString *)getUUID;

@end






//
//  UUID.m
//
//  Created by codeRiding on 2015/11/13.
//  Copyright (c) 2015年 com.sanfield.hyw. All rights reserved.
//

#import "UUID.h"
#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@implementation UUID

+(NSString *)getUUID
{
    KeychainItemWrapper *keyChainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.product.SFSafetyFirst.uuid" accessGroup:@"com.product.SFSafetyFirst"];
    id UUID = [keyChainWrapper objectForKey:(__bridge id)kSecValueData];
    BOOL isEmpty = false;
    if ([UUID isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)UUID;
        if (d.allKeys.count < 1) {
            isEmpty = true;
        }
    }else if([UUID isKindOfClass:[NSString class]]){
        NSString *d = (NSString *)UUID;
        if (d == nil || d.length == 0) {
            isEmpty = true;
        }
    }
    
    if (isEmpty) {
        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keyChainWrapper setObject:UUID forKey:(__bridge id)kSecValueData];
    }
    
    // 处理一下分隔线
    UUID = [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return UUID;
}

@end


```