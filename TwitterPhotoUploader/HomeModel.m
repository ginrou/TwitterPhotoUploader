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

@property (nonatomic, strong) NSMutableArray *homeTimeLine;
@property (nonatomic, strong) NSMutableArray *userTimeLine;

@property (nonatomic, assign) BOOL loadingMore;

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
        _homeTimeLine = [NSMutableArray array];
        _userTimeLine = [NSMutableArray array];
    }
    return self;
}

- (void)switchTimeLineType:(HomeModelTimeLineType)timeLineType
{
    _timeLineType = timeLineType;
    [self retriveTweetsFromServer];
}

- (NSMutableArray *)timeLineArrayForType:(HomeModelTimeLineType)type
{
    if (type == HomeModelHomeTimeLine) {
        return self.homeTimeLine;
    } else {
        return self.userTimeLine;
    }

}

- (NSMutableArray *)currentTimeLine
{
    return [self timeLineArrayForType:self.timeLineType];
}

- (void)retriveTweetsFromServer
{
    [self retriveTweetsFromServerForType:self.timeLineType];
}

- (void)retriveTweetsFromServerForType:(HomeModelTimeLineType)timeLineType
{
    [self retriveTweetPromiseForType:timeLineType olderThan:nil]
    .then(^(NSArray *json, NSHTTPURLResponse *response){
        return [self mergeTweetsAndCallDelegatePromiseTweetForType:timeLineType
                                                     newTweetsJSON:json];
    })
    .catch(^(NSError *error){
        [self.delegate homeModel:self retriveTweetsCompleted:error];
    });
}

- (void)retriveMoreTweetsFromServer
{
    [self retriveMoreTweetsFromServerForType:self.timeLineType];
}

- (void)retriveMoreTweetsFromServerForType:(HomeModelTimeLineType)timeLineType
{
    Tweet *oldestTweet = [[self timeLineArrayForType:timeLineType] lastObject];

    self.loadingMore = YES;
    [self retriveTweetPromiseForType:timeLineType olderThan:oldestTweet]
    .then(^(NSArray *json, NSHTTPURLResponse *response){
        return [self mergeTweetsAndCallDelegatePromiseTweetForType:timeLineType
                                                     newTweetsJSON:json];
    })
    .catch(^(NSError *error){
        [self.delegate homeModel:self retriveTweetsCompleted:error];
    }).finally(^(){
        self.loadingMore = NO;
    });
}

- (PMKPromise *)retriveTweetPromiseForType:(HomeModelTimeLineType)type olderThan:(Tweet *)olderThan
{
    switch (type) {
        case HomeModelHomeTimeLine:
            return [TwitterClient getStatusesHomeTimelineForAccount:self.loginAccount
                                                         screenName:self.loginUser.userID
                                                              maxID:olderThan.ID];
            break;
        case HomeModelUserTimeLine:
            return [TwitterClient getStatusesUserTimelineForAccount:self.loginAccount
                                                         screenName:self.loginUser.screenName
                                                              maxID:olderThan.ID];
            break;
    }
    return nil;
}

- (PMKPromise *)mergeTweetsAndCallDelegatePromiseTweetForType:(HomeModelTimeLineType)type newTweetsJSON:(NSArray *)json
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        NSMutableArray *array = [self timeLineArrayForType:type];

        // add tweets
        for (NSDictionary *tweetDict in json) {
            Tweet *tweet = [[Tweet alloc] initWithDict:tweetDict];
            if ([array containsObject:tweet] == NO) {
                [array addObject:tweet];
            }
        }

        // order by post date
        [array sortUsingComparator:^NSComparisonResult(Tweet *tweet1, Tweet *tweet2 ) {
            return [tweet2.createdAt compare:tweet1.createdAt];
        }];

        // call delegate
        [self.delegate homeModel:self retriveTweetsCompleted:nil];

    }];
}


- (NSInteger)tweetsCount { return [[self currentTimeLine] count]; }
- (Tweet *)tweetAtIndex:(NSInteger)index { return [self currentTimeLine][index]; }

@end
