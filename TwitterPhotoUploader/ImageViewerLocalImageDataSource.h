//
//  ImageViewerLocalImageDataSource.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/06.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalImage.h"
#import "ImageViewer.h"

@interface ImageViewerLocalImageDataSource : NSObject <ImageViewerDataSource>

/// ImageViewerで表示するLocalImage
@property (nonatomic, strong) NSArray *localImages;
@property (nonatomic, weak) ImageViewer *imageViewer;
@end
