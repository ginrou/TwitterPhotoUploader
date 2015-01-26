//
//  TwitterClient.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import Foundation;
@import Accounts;
@import Social;

#import <PromiseKit.h>

@interface TwitterClient : NSObject

/// <- @[ (NSDictionary of response JSON), (NSHTTPURLResponse)]
+ (PMKPromise *)getHelpConfigurationForAccount:(ACAccount *)account;

+ (PMKPromise *)getUsersShowForAccount:(ACAccount *)account screenName:(NSString *)screenName;

/// <- @[ (NSDictionary of response JSON), ...]
+ (PMKPromise *)getUsersShowForAccounts:(NSArray *)accounts;

+ (PMKPromise *)postMediaUploadForAccount:(ACAccount *)account
                                     data:(NSData *)imageData
                                 mimeType:(NSString *)mimeType
                                 filename:(NSString *)filename;

+ (PMKPromise *)postStatusUpdateForAccount:(ACAccount *)account
                                    status:(NSString *)status
                                  mediaIDs:(NSString *)mediaIDs; // example: @"460938773744717825,460938773744717826"

+ (PMKPromise *)getStatusesUserTimelineForAccount:(ACAccount *)account
                                       screenName:(NSString *)screenName;

+ (PMKPromise *)getStatusesHomeTimelineForAccount:(ACAccount *)account
                                       screenName:(NSString *)screenName;

@end
