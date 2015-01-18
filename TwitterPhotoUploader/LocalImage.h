//
//  LocalImage.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import Foundation;
@import UIKit;
@import Photos;

/**
 * LocalImage
 *
 * 端末内に保存されているデータのエンティティ
 */

@interface LocalImage : NSObject

@property (nonatomic) PHAsset *asset;

@property (nonatomic) NSURL *fileURL;
@property (nonatomic) NSString *dataUTI;
@property (nonatomic) NSUInteger fileSize;

@end

@interface NSObject (HashKey)
- (NSString *)hashKey;
@end