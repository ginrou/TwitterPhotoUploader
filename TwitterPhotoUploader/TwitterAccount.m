//
//  TwitterAccount.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "TwitterAccount.h"
#import "AccountDataStore.h"

@implementation TwitterAccount

+ (BOOL)isGrantedForService
{
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    return accountType.accessGranted;
}

+ (BOOL)isAccountRegistered
{
    return [self accounts].count > 0;
}

+ (NSArray *)accounts
{
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    return [accountStore accountsWithAccountType:accountType];
}

+ (ACAccount *)defaultAccount
{
    TwitterUser *defaultUser = [AccountDataStore loadDefaultTwitterAccount];
    for (ACAccount *account in [self accounts]) {
        if ([account.username isEqualToString:defaultUser.name]) {
            return account;
        }
    }
    return nil;
}

+ (PMKPromise *)getGrantForService
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if ([self isGrantedForService]) {
            fulfill(nil);
            return;
        }

        // Grantを得るためにはAccessTokenを得るしかなさそう
        [self retriveAccessToken]
        .then(^(id obj){
            fulfill(obj);
        }).catch(^(NSError *error){
            reject(error);
        });

    }];
}


+ (PMKPromise *)retriveAccessToken
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        ACAccountStore *accountStore = [ACAccountStore new];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {

            if (granted == NO || error != nil) {
                reject(error);
            } else {
                fulfill([accountStore accountsWithAccountType:accountType]);
            }

        }];

    }];
}

+ (PMKPromise *)retriveAccessTokenForAccount:(ACAccount *)account
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        [[self class] retriveAccessToken].then(^(NSArray *accounts){

            for (ACAccount *grantedAccount in accounts) {
                if ([account.identifier isEqualToString:grantedAccount.identifier]) {
                    fulfill(grantedAccount);
                    return;
                }

            }

            reject(nil);

        });
    }];
}

@end
