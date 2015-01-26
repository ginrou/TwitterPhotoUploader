//
//  TwitterAccount.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import Foundation;
@import Accounts;

#import <PromiseKit.h>

@interface TwitterAccount : NSObject

+ (BOOL)isGrantedForService;
+ (BOOL)isAccountRegistered;
+ (PMKPromise *)getGrantForService;

/// <- NSArray of granted ACAccount
+ (PMKPromise *)retriveAccessToken;

/// <- granted ACAccount
+ (PMKPromise *)retriveAccessTokenForAccount:(ACAccount *)account;

/// returns Array of ACAccounts objects
+ (NSArray *)accounts;

@end
