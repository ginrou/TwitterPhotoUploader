//
//  AccountDataStore.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/18.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TwitterAccount.h"
#import "TwitterUser.h"

@interface AccountDataStore : NSObject
+ (void)saveDefaultTwitterAccount:(TwitterUser *)user;
+ (TwitterUser *)loadDefaultTwitterAccount;
+ (BOOL)defaultAccountSet;
@end
