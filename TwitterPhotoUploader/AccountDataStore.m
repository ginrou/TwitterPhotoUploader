//
//  AccountDataStore.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/18.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "AccountDataStore.h"

static NSString *const kDefaultTwitterAccountKey = @"AccountDataStoreDefaultTwitterAccount";

NSString * const AccountDataStoreDefaultAccountChangedNotificationKey = @"AccountDataStoreDefaultAccountChangedNotificationKey";

@implementation AccountDataStore

+ (void)saveDefaultTwitterAccount:(TwitterUser *)user
{
    if ([user isEqual:[self loadDefaultTwitterAccount]]) return;

    [[NSUserDefaults standardUserDefaults] setObject:[user dictionaryRepresentation] forKey:kDefaultTwitterAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:AccountDataStoreDefaultAccountChangedNotificationKey
                                                        object:nil];
}

+ (TwitterUser *)loadDefaultTwitterAccount
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTwitterAccountKey];
    return [[TwitterUser alloc] initWithDict:dict];
}

+ (BOOL)defaultAccountSet
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTwitterAccountKey] != nil;
}

@end
