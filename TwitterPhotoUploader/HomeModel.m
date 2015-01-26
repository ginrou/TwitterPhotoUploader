//
//  HomeModel.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/18.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "HomeModel.h"

#import "AccountDataStore.h"
#import "TwitterAccount.h"
#import "TwitterClient.h"

@interface HomeModel ()
@property (nonatomic, readwrite) TwitterUser *loginUser;
@property (nonatomic, strong) ACAccount *loginAccount;


@property (nonatomic, strong) NSMutableArray *tweets;
@end

@implementation HomeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loginUser = [AccountDataStore loadDefaultTwitterAccount];

        [[TwitterAccount accounts] enumerateObjectsUsingBlock:^(ACAccount *account, NSUInteger idx, BOOL *stop) {
            if ([account.username isEqualToString:_loginUser.screenName]) {
                _loginAccount = account;
                *stop = YES;
            }
        }];

        _timeLineType = HomeModelHomeTimeLine;
        _tweets = [NSMutableArray array];
        [self retriveTweetsFromServer];
    }
    return self;
}

- (void)switchTimeLineType:(HomeModelTimeLineType)timeLineType
{
    _timeLineType = timeLineType;
    [self retriveTweetsFromServer];
}

- (void)retriveTweetsFromServer
{
    [self retriveTweetPromise]
    .then(^(NSArray *json, NSHTTPURLResponse *response){
        [self.tweets removeAllObjects];
        for (NSDictionary *tweetDict in json) {
            [self.tweets addObject:[[Tweet alloc] initWithDict:tweetDict]];
        }
        [self.delegate homeModel:self retriveTweetsCompleted:nil];
    })
    .catch(^(NSError *error){
        [self.delegate homeModel:self retriveTweetsCompleted:error];
    });

}

- (PMKPromise *)retriveTweetPromise
{
    switch (self.timeLineType) {
        case HomeModelHomeTimeLine:
            return [TwitterClient getStatusesHomeTimelineForAccount:self.loginAccount
                                                         screenName:self.loginUser.userID];
            break;
        case HomeModelUserTimeLine:
            return [TwitterClient getStatusesUserTimelineForAccount:self.loginAccount
                                                         screenName:self.loginUser.userID];
            break;
    }
    return nil;
}

- (NSInteger)tweetsCount { return self.tweets.count; }
- (Tweet *)tweetAtIndex:(NSInteger)index { return self.tweets[index]; }

@end
