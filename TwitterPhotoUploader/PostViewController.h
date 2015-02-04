//
//  PostViewController.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol PostViewControllerDelegate;

@interface PostViewController : UIViewController
@property (nonatomic, weak) id<PostViewControllerDelegate> delegate;
@end

@protocol PostViewControllerDelegate <NSObject>
- (void)postViewControllerDidCanceled:(PostViewController *)postViewController;
- (void)postViewController:(PostViewController *)postViewController postCompleted:(Tweet *)tweet;
@end
