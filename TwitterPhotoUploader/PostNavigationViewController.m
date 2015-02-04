//
//  PostNavigationViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/03.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PostNavigationViewController.h"
#import "PostViewController.h"

@interface PostNavigationViewController () <PostViewControllerDelegate>

@end

@implementation PostNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PostViewController *postViewController = self.viewControllers.firstObject;
    postViewController.delegate = self;
}

#pragma mark - PostViewControllerDeleagte
- (void)postViewControllerDidCanceled:(PostViewController *)postViewController
{
    [self.postDelegate postNavigationController:self postCompleted:nil];
}

- (void)postViewController:(PostViewController *)postViewController postCompleted:(Tweet *)tweet
{
    [self.postDelegate postNavigationController:self postCompleted:tweet];
}

@end
