//
//  OCTUsersSearchResult.m
//  OctoKit
//
//  Created by leichunfeng on 16/3/27.
//  Copyright © 2016年 GitHub. All rights reserved.
//

#import "OCTUsersSearchResult.h"

@implementation OCTUsersSearchResult

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
		@"totalCount": @"total_count",
		@"incompleteResults": @"incomplete_results",
		@"users": @"items",
	}];
}

+ (NSValueTransformer *)usersJSONTransformer {
	return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:OCTUser.class];
}

@end
