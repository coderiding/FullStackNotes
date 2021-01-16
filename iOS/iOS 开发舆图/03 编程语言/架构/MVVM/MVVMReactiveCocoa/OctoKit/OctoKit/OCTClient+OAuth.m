//
//  OCTClient+OAuth.m
//  OctoKit
//
//  Created by leichunfeng on 16/5/15.
//  Copyright © 2016年 GitHub. All rights reserved.
//

#import "OCTClient+OAuth.h"
#import "OCTClient+Private.h"

@interface OCTClient ()

// Returns any OAuth client ID previously given to +setClientID:clientSecret:.
+ (NSString *)clientID;

// Returns any OAuth client secret previously given to
// +setClientID:clientSecret:.
+ (NSString *)clientSecret;

@end

@implementation OCTClient (OAuth)

- (RACSignal *)exchangeAccessTokenWithCode:(NSString *)code {
	NSParameterAssert(code.length > 0);
	
	NSString *clientID = self.class.clientID;
	NSString *clientSecret = self.class.clientSecret;
	
	NSAssert(clientID != nil && clientSecret != nil, @"+setClientID:clientSecret: must be invoked before calling %@", NSStringFromSelector(_cmd));
	
	NSDictionary *parameters = @{
		@"client_id": clientID,
		@"client_secret": clientSecret,
		@"code": code,
	};
	
	// We're using -requestWithMethod: for its parameter encoding and
	// User-Agent behavior, but we'll replace the key properties so we
	// can POST to another host.
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"" parameters:parameters];
	
	request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	request.URL = [NSURL URLWithString:@"login/oauth/access_token" relativeToURL:[OCTServer dotComServer].baseWebURL];
	
	// The `Accept` string we normally use (where we specify the beta
	// version of the API) doesn't work for this endpoint. Just plain
	// JSON.
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	return [[self
		enqueueRequest:request resultClass:[OCTAccessToken class]]
		oct_parsedResults];
}

@end
