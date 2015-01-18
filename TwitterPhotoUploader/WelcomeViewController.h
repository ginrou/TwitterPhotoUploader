//
//  WelcomeViewController.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PromiseKit.h>

@interface WelcomeViewController : UIViewController
+ (BOOL)isAllServiceReady;
+ (void)blockUntilAllServiceReady:(UIWindow *)window onComplete:(void(^)(BOOL rootViewControllerChanged))onComplete;
@end
