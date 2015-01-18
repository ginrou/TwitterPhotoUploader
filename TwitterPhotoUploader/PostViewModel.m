//
//  PostViewModel.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PostViewModel.h"

@import Social;
@import Accounts;
@import Twitter;

#import "TwitterAccount.h"
#import "TwitterClient.h"

@interface PostViewModel ()
@property (nonatomic, strong) ACAccount *account;
@property (nonatomic, strong) NSMutableDictionary *registerdUsers;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableDictionary *uploadedImageIDs;

/// Media/Upload の途中にPostが押されたときに待機中かどうかのフラグ
@property (atomic) BOOL postPending;
@end

@implementation PostViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.account = [TwitterAccount accounts].firstObject;
        self.registerdUsers = [NSMutableDictionary dictionary];
        self.images = [NSMutableArray array];
        self.uploadedImageIDs = [NSMutableDictionary dictionary];
        [self lookupRegisterdUsers];

    }
    return self;
}

#pragma mark - Post User
- (TwitterUser *)postUser
{
    return self.registerdUsers[self.account.username];
}

- (void)lookupRegisterdUsers
{
    [TwitterClient getUsersShowForAccount:self.account screenName:self.account.username]
    .then(^(NSDictionary *json, NSHTTPURLResponse *response){
        TwitterUser *user = [[TwitterUser alloc] initWithDict:json];
        self.registerdUsers[self.account.username] = user;

        [self.delegate postViewModel:self lookupUserCompleted:user];

    });
}


#pragma mark - Post Images
- (void)addImage:(LocalImage *)image
{
    [self.images addObject:image];
    [self uploadImage:image].then(^(id arg){

        if (self.uploadedImageIDs[image.hashKey] != nil) {
            [self.delegate postViewModel:self updateImageCompleted:image];
        }

        if (self.postPending) {
            [self post];
        }

    });
}

- (LocalImage *)imageAtIndex:(NSInteger)index
{
    return self.images[index];
}

- (void)removeImage:(LocalImage *)image
{
    [self.images removeObject:image];
    [self.uploadedImageIDs removeObjectForKey:image.hashKey];
}

- (NSUInteger)imageCounts
{
    return self.images.count;
}

- (NSUInteger)indexOfImage:(LocalImage *)image
{
    return [self.images indexOfObject:image];
}

- (BOOL)isUploading:(LocalImage *)image
{
    return [self.images containsObject:image] && self.uploadedImageIDs[image.hashKey] == nil;
}

- (PMKPromise *)uploadImage:(LocalImage *)image
{
    PMKPromise *loadImage = [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [[PHImageManager defaultManager] requestImageDataForAsset:image.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {

            NSAssert(imageData != nil, @"failed to load image");

            fulfill(PMKManifold(imageData, dataUTI, info));

        }];
    }];

    return loadImage.then(^(NSData *imageData, NSString *dataUTI, NSDictionary *info){

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

            if ([self.images containsObject:image]) {
                NSString *mediaIDString = json[@"media_id_string"];
                self.uploadedImageIDs[image.hashKey] = mediaIDString;
            }
        });
    });
    
}


- (void)post
{

    NSAssert(self.status != nil, @"status is nil");

    if (self.images.count != self.uploadedImageIDs.count) {
        self.postPending = YES;
        return;
    }

    NSString *mediaIDs;
    if (self.images.count == 0) {
        // do notihng. mediaIDs will be nil
    } else if (self.images.count == 1) {
        mediaIDs = self.uploadedImageIDs.allValues.firstObject;
    } else {
        mediaIDs = [NSMutableString stringWithString:self.uploadedImageIDs.allValues.firstObject];
        for (int i = 1; i < self.images.count; ++i) {
            LocalImage *image = self.images[i];
            [(NSMutableString *)mediaIDs appendFormat:@",%@", self.uploadedImageIDs[image.hashKey]];
        }
    }

    [TwitterClient postStatusUpdateForAccount:self.account
                                       status:self.status
                                     mediaIDs:mediaIDs]
    .then(^(NSDictionary *json, NSHTTPURLResponse *response) {

        Tweet *tweet = [[Tweet alloc] initWithDict:json];
        _postResult = tweet;
        self.postPending = NO;
        [self.delegate postViewModel:self postCompleted:tweet];

    }).catch(^(NSError *error){

        NSLog(@"%@", error);

    });

}

@end
