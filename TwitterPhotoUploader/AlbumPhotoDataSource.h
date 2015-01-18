//
//  AlbumPhotoDataSource.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import UIKit;

#import "LocalImage.h"

@interface AlbumPhotoDataSource : NSObject
- (NSUInteger)numberOfPhotos;
- (LocalImage *)imageAtIndex:(NSUInteger)index;

- (void)selectImage:(LocalImage *)image;
- (BOOL)isImageSelected:(LocalImage *)image;
- (void)deselectImage:(LocalImage *)image;
@end
