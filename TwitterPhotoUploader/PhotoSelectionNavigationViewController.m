//
//  PhotoSelectionNavigationViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PhotoSelectionNavigationViewController.h"
#import "PhotoSelectViewController.h"

@interface PhotoSelectionNavigationViewController () <
PhotoSelectViewControllerDelegate
>

@end

@implementation PhotoSelectionNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self.viewControllers.firstObject isKindOfClass:[PhotoSelectViewController class]]) {
        PhotoSelectViewController *rootViewController = self.viewControllers.firstObject;
        rootViewController.delegate = self;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![viewController conformsToProtocol:@protocol(PhotoSelectionViewControllerProtocol)]) {
        NSLog(@"out!!!");
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - PhotoSelectViewControllerDelegate
- (void)photoSelectViewControler:(PhotoSelectViewController *)sender
                   imageSelected:(LocalImage *)image
{
    [self.photoSelectionDelegate photoSelectionNavigationViewController:self
                                                          imageSelected:image];
}

@end
