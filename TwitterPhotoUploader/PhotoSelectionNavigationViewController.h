//
//  PhotoSelectionNavigationViewController.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalImage.h"

@protocol PhotoSelectionNavigationDelegate;

/**
 * PhotoSelectionNavigationViewControllerの
 * childViewControllerが準拠しないといけないメソッド
 * TODO : 依存関係がおかしいのでこのプロトコルだけ切り出す
 */
@protocol PhotoSelectionViewControllerProtocol <NSObject>
- (void)imageDeselcted:(LocalImage *)image;
@end

@interface PhotoSelectionNavigationViewController : UINavigationController
@property (nonatomic, weak) id<PhotoSelectionNavigationDelegate> photoSelectionDelegate;
@end

@protocol PhotoSelectionNavigationDelegate <NSObject>
- (void)photoSelectionNavigationViewController:(PhotoSelectionNavigationViewController *)sender
                                 imageSelected:(LocalImage *)image;
@end