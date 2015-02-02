//
//  ImageViewerTweetDataSource.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/02.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "ImageViewerTweetDataSource.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation ImageViewerTweetDataSource

- (NSUInteger)imageViewerNumberOfImages:(ImageViewer *)imageViewer
{
    return self.tweet.mediaList.count;
}

- (void)imageViewer:(ImageViewer *)imageViewer
    contentsAtIndex:(NSInteger)index
           callback:(void (^)(NSInteger, NSString *, UIImage *))callback
{
    TwitterPhoto *photo = self.tweet.mediaList[index];
    [[SDWebImageManager sharedManager] downloadImageWithURL:photo.mediaURLorig options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        if (finished == NO) return;

        NSString *description = [[self class] descriptionForPhoto:photo];
        callback(index, description, image);

    }];
}

+ (NSString *)descriptionForPhoto:(TwitterPhoto *)photo
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"URL : %@\n", photo.mediaURLorig];
    [description appendFormat:@"Image Size : %@x%@\n", photo.width, photo.height];

    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:photo.mediaURLorig]) {
        NSString *cachepath = [[SDImageCache sharedImageCache] defaultCachePathForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:photo.mediaURLorig]];
        NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:cachepath error:nil];
        NSInteger fileSize = [fileAttr[NSFileSize] integerValue];
        [description appendFormat:@"File Size : %@[kb]", @(fileSize/1024)];
    }

    return description;
}

@end
