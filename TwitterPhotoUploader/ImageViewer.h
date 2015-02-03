//
//  ImageViewer.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/27.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewerDataSource;
@protocol ImageViewerDelegate;

/**
 * @class ImageViewer 
 * 画像をフルスクリーンで表示するためのImageViewer
 * データソースとして ImageViewerDataSource に準拠する
 * オブジェクトを渡す必要がある
 */
@interface ImageViewer : UIViewController
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<ImageViewerDelegate> delegate;
@property (nonatomic, weak) id<ImageViewerDataSource> dataSource;
@end

@protocol ImageViewerDataSource <NSObject>
@required
- (NSUInteger)imageViewerNumberOfImages:(ImageViewer *)imageViewer;
- (void)imageViewer:(ImageViewer *)imageViewer
    contentsAtIndex:(NSInteger)index
           callback:(void (^)(NSInteger rowKey, NSString *description, UIImage *image))callback;
@optional
// TODO: need impl?
@end

@protocol ImageViewerDelegate <NSObject>
- (void)imageViewerCloseButtonTapped:(ImageViewer *)imageViewer;
@end