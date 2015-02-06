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

@interface PhotoUploader ()
@property (nonatomic, strong) NSMutableSet *uploadingImages;
@property (nonatomic, strong) NSMutableSet *uploadedImages;
@end

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
    }
    return self;
}

- (NSString *)mediaIDStringFromLocalImage:(LocalImage *)localImage
{
    for (UploadedImage *image in self.uploadedImages) {
        if (image.localImage == localImage) {
            return image.uploadResult[@"media_id_string"];
        }
    }
    return nil;
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

        [TwitterClient postMediaUploadForAccount:self.account
                                            data:imageData
                                        mimeType:mimeType
                                        filename:filename]
        .then(^(NSDictionary *json, NSHTTPURLResponse *response){

            if (self.uploadedImages containsObject:<#(id)#>) {

            }


        });


    });


}

@end
