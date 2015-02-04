//
//  PostNavigationViewController.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/03.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@protocol PostNavigationViewControllerDelegate;

/**
 * @class PostNavigationViewController
 * 投稿処理の一連の画面遷移を管理するNavigationController
 */
@interface PostNavigationViewController : UINavigationController
@property (nonatomic, weak) id<PostNavigationViewControllerDelegate> postDelegate;
@end

@protocol PostNavigationViewControllerDelegate <NSObject>
/**
 * 投稿処理一連の処理が完了したときに呼ばれる。投稿完了していない場合はpostTweetがnilになる
 */
- (void)postNavigationController:(PostNavigationViewController *)sender postCompleted:(Tweet *)postTweet;
@end