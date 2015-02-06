//
//  PhotoUploader.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/04.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Accounts;

#import "TwitterAccount.h"
#import "LocalImage.h"

@interface PhotoUploader : NSObject

/// singleton instance
+ (instancetype)sharedUploader;


@property (nonatomic, strong) ACAccount *account;

/**
 * @method uploadImage
 * https://upload.twitter.com/1.1/media/upload.json に対して写真をアップロードします。
 * アップロードが成功した時には PhotoUploaderUploadSuccessNotificationKey を
 * アップロードが失敗した時には PhotoUploaderUploadFailureNotificationKey を
 * キーとしたNSNotificationが通知されます。
 * 既にアップロード済みだった場合は PhotoUploaderUploadSuccessNotificationKey が通知されます。
 */
- (void)uploadIamge:(LocalImage *)localImage;

- (NSString *)mediaIDStringFromLocalImage:(LocalImage *)localImage;

/// アップロード済みのLocalImage
- (NSArray *)allUploadedImages;

@end

/**
 * 写真アップロードに成功した時に通知されるNotificationのキー
 * @param userInfo = @{ @"localImage" : アップロードした画像のLocalImageオブジェクト, @"json" : アップロード結果のjson(NSDictionary) }
 */
FOUNDATION_EXPORT NSString * const PhotoUploaderUploadSuccessNotificationKey;


/**
 * 写真アップロードに失敗した時に通知されるNotificationのキー
 * @param userInfo = @{ @"localImage" : アップロードした画像のLocalImageオブジェクト, @"error" : エラー構造体 }
 */
FOUNDATION_EXPORT NSString * const PhotoUploaderUploadFailureNotificationKey;