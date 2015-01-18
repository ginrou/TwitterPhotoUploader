//
//  PhotoSelectViewController.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/09.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSelectionNavigationViewController.h"
#import "LocalImage.h"

@protocol PhotoSelectViewControllerDelegate;

@interface PhotoSelectViewController : UIViewController <PhotoSelectionViewControllerProtocol>
@property (nonatomic, weak) id<PhotoSelectViewControllerDelegate> delegate;
@end

@protocol PhotoSelectViewControllerDelegate <NSObject>
- (void)photoSelectViewControler:(PhotoSelectViewController *)sender
                   imageSelected:(LocalImage *)image;
@end