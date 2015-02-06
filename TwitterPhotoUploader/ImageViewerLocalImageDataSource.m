//
//  ImageViewerLocalImageDataSource.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/06.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "ImageViewerLocalImageDataSource.h"
#import "PhotoUploader.h"

@interface ImageViewerLocalImageDataSource ()

@end

@implementation ImageViewerLocalImageDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(photoUploadSuccess:)
                                                     name:PhotoUploaderUploadSuccessNotificationKey
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(photoUploadFailure:)
                                                     name:PhotoUploaderUploadFailureNotificationKey
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSUInteger)imageViewerNumberOfImages:(ImageViewer *)imageViewer
{
    return self.localImages.count;
}

- (void)imageViewer:(ImageViewer *)imageViewer
    contentsAtIndex:(NSInteger)index
           callback:(void (^)(NSInteger, NSString *, UIImage *))callback
{
    LocalImage *localImage = self.localImages[index];
    CGSize imageSize = self.imageViewer.view.frame.size;
    [[PHImageManager defaultManager] requestImageForAsset:localImage.asset targetSize:imageSize contentMode:PHImageContentModeDefault options:0 resultHandler:^(UIImage *result, NSDictionary *info) {

        NSString *description = [self descriptionForImage:localImage];
        callback(index, description, result);
    }];
}

- (NSString *)descriptionForImage:(LocalImage *)image
{
    if ([[PhotoUploader sharedUploader] isUploading:image]) {
        return @"Uploading...";
    }

    NSDictionary *uploadResult = [[PhotoUploader sharedUploader] uploadResultForImage:image];
    if (uploadResult) {
        return [NSString stringWithFormat:@"Uploaded : %@", uploadResult.description];
    }

    NSError *uploadError = [[PhotoUploader sharedUploader] uploadErrorForImage:image];
    if (uploadError) {
        return [NSString stringWithFormat:@"Upload Failed : %@", uploadError];
    }

    return @"Other Pattern... should not come here...";
}


- (void)photoUploadSuccess:(NSNotification *)notification
{
    // TODO 更新処理
}

- (void)photoUploadFailure:(NSNotification *)notification
{
    // TODO 更新処理
}

@end
