//
//  PhotoUploader.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/04.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PhotoUploader.h"

#import "TwitterAccount.h"
#import "TwitterClient.h"

@interface UploadedImage : NSObject
@property (nonatomic, strong) LocalImage *localImage;
@property (nonatomic, strong) NSDictionary *uploadResult;
@end

@implementation UploadedImage
@end

@interface UploadFailedImage : NSObject
@property (nonatomic, strong) LocalImage *localImage;
@property (nonatomic, strong) NSError *error;
@end

@implementation UploadFailedImage
@end

@interface PhotoUploader ()
@property (nonatomic, strong) NSMutableSet *uploadingImages;
@property (nonatomic, strong) NSMutableSet *uploadedImages;
@property (nonatomic, strong) NSMutableSet *uploadFailedImages;
@end

NSString * const PhotoUploaderUploadSuccessNotificationKey = @"PhotoUploaderUploadSuccessNotification";
NSString * const PhotoUploaderUploadFailureNotificationKey = @"PhotoUploaderUploadFailureNotification";

@implementation PhotoUploader

+ (instancetype)sharedUploader
{
    static PhotoUploader *sharedUploader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUploader = [[PhotoUploader alloc] init];
    });
    return sharedUploader;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _account = [TwitterAccount defaultAccount];
        _uploadedImages = [NSMutableSet set];
        _uploadingImages = [NSMutableSet set];
        _uploadFailedImages = [NSMutableSet set];
    }
    return self;
}

- (UploadedImage *)uploadedImageForImage:(LocalImage *)localImage
{
    for (UploadedImage *image in self.uploadedImages) {
        if (image.localImage == localImage) return image;
    }
    return nil;
}

- (NSDictionary *)uploadResultForImage:(LocalImage *)localImage
{
    return [self uploadedImageForImage:localImage].uploadResult;
}

- (NSError *)uploadErrorForImage:(LocalImage *)localImage
{
    for (UploadFailedImage *failed in self.uploadFailedImages) {
        if (failed.localImage == localImage) return failed.error;
    }
    return nil;
}

- (NSString *)mediaIDStringFromLocalImage:(LocalImage *)localImage
{
    return [self uploadResultForImage:localImage][@"media_id_string"];
}

- (BOOL)isUploading:(LocalImage *)localImage
{
    return [self.uploadingImages containsObject:localImage];
}

- (NSArray *)allUploadedImages
{
    NSMutableArray *result = [NSMutableArray array];
    for (UploadedImage *image in self.uploadedImages) {
        [result addObject:image];
    }
    return result;
}

- (void)uploadIamge:(LocalImage *)localImage
{
    if ([self uploadedImageForImage:localImage] != nil) {
        [self postUploadSuccessNotification:[self uploadedImageForImage:localImage]];
        return;
    }

    [self.uploadFailedImages enumerateObjectsUsingBlock:^(UploadFailedImage *image, BOOL *stop) {
        if (image.localImage == localImage) {
            [self.uploadFailedImages removeObject:localImage];
            *stop = YES;
        }
    }];
    [self.uploadingImages addObject:localImage];

    [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        [[PHImageManager defaultManager] requestImageDataForAsset:localImage.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {

            NSAssert(imageData != nil, @"failed to load image");
            fulfill(PMKManifold(imageData, dataUTI, info));

        }];

    }]
    .then(^(NSData *imageData, NSString *dataUTI, NSDictionary *info){

        NSString *mimeType;
        if ([dataUTI isEqualToString:@"public.jpeg"]) {
            mimeType = @"image/jpeg";
        } else if ([dataUTI isEqualToString:@"public.png"]) {
            mimeType = @"image/png";
        }

        NSURL *fileURL = info[@"PHImageFileURLKey"];
        NSString *filename = [NSString stringWithFormat:@"%@", [fileURL.absoluteString componentsSeparatedByString:@"/"].lastObject];

        return [TwitterClient postMediaUploadForAccount:self.account
                                                   data:imageData
                                               mimeType:mimeType
                                               filename:filename]
        .then(^(NSDictionary *json, NSHTTPURLResponse *response){

            [self.uploadingImages removeObject:localImage];
            UploadedImage *uploaded = [[UploadedImage alloc] init];
            uploaded.localImage = localImage;
            uploaded.uploadResult = json;
            [self.uploadedImages addObject:uploaded];
            [self postUploadSuccessNotification:uploaded];

        });

    })
    .catch(^(NSError *error){

        [self.uploadingImages removeObject:localImage];
        UploadFailedImage *failed = [[UploadFailedImage alloc] init];
        failed.localImage = localImage;
        failed.error = error;
        [self.uploadFailedImages addObject:failed];
        [self postUploadFailureNotification:failed];

    });


}

- (void)postUploadSuccessNotification:(UploadedImage *)uploaded
{
    NSDictionary *userInfo = @{ @"localImage": uploaded.localImage,
                                @"json": uploaded.uploadResult};
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoUploaderUploadSuccessNotificationKey
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)postUploadFailureNotification:(UploadFailedImage *)uploadFailed
{
    NSDictionary *userInfo = @{ @"localImage": uploadFailed.localImage,
                                @"error": uploadFailed.error};
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoUploaderUploadFailureNotificationKey
                                                        object:nil
                                                      userInfo:userInfo];
}

@end
