//
//  HomeModel.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/18.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tweet.h"

typedef NS_ENUM(NSUInteger, HomeModelTimeLineType) {
    HomeModelHomeTimeLine,
    HomeModelUserTimeLine
};

@protocol HomeModelDelegate;

@interface HomeModel : NSObject
@property (nonatomic, weak) id<HomeModelDelegate> delegate;
@property (nonatomic, readonly) TwitterUser *loginUser;

@property (nonatomic, readonly) HomeModelTimeLineType timeLineType;

- (void)switchTimeLineType:(HomeModelTimeLineType)timeLineType;
- (void)retriveTweetsFromServer;

- (NSInteger)tweetsCount;
- (Tweet *)tweetAtIndex:(NSInteger)index;

@end

@protocol HomeModelDelegate <NSObject>
- (void)homeModel:(HomeModel *)sender retriveTweetsCompleted:(NSError *)error;

@end