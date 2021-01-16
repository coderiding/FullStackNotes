//
//  OCTClient+OAuth.h
//  OctoKit
//
//  Created by leichunfeng on 16/5/15.
//  Copyright © 2016年 GitHub. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTClient (OAuth)

- (RACSignal *)exchangeAccessTokenWithCode:(NSString *)code;

@end
