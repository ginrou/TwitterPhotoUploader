
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
#import "PhotoUploader.h"

@interface PostViewModel ()
@property (nonatomic, strong) ACAccount *account;
@property (nonatomic, strong) NSMutableDictionary *registerdUsers;
@property (nonatomic, strong, readwrite) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *uploadingImages;

@property (nonatomic, assign) BOOL postPending;

@end

@implementation PostViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.account = [TwitterAccount accounts].firstObject;
        self.registerdUsers = [NSMutableDictionary dictionary];
        self.status = @"";
        self.images = [NSMutableArray array];
        self.uploadingImages = [NSMutableArray array];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(photoUploadSuccess:)
                                                     name:PhotoUploaderUploadSuccessNotificationKey
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(photoUploadFailure:)
                                                     name:PhotoUploaderUploadFailureNotificationKey
                                                   object:nil];

        [self lookupRegisterdUsers];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.uploadingImages addObject:image];
    if ([self.images containsObject:image] == NO) [self.images addObject:image];
    [[PhotoUploader sharedUploader] uploadIamge:image];
}

- (LocalImage *)imageAtIndex:(NSInteger)index
{
    return self.images[index];
}

- (void)removeImage:(LocalImage *)image
{
    [self.images removeObject:image];
    [self.uploadingImages removeObject:image];
    self.postPending = NO;
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
    return [self.uploadingImages containsObject:image];
}

- (BOOL)uploadFailed:(LocalImage *)image
{
    return [[PhotoUploader sharedUploader] uploadErrorForImage:image] != nil;
}

- (void)post
{
    if (self.uploadingImages.count > 0) {
        self.postPending = YES;
        return;
    }

    NSString *mediaIDs = [self mediaIDString];
    NSAssert(self.status.length > 0 || mediaIDs != nil, @"incomplete parameters");

    [TwitterClient postStatusUpdateForAccount:self.account
                                       status:self.status
                                     mediaIDs:mediaIDs]
    .then(^(NSDictionary *json, NSHTTPURLResponse *response) {

        Tweet *tweet = [[Tweet alloc] initWithDict:json];
        _postResult = tweet;
        [self.delegate postViewModel:self postCompleted:tweet];

    }).catch(^(NSError *error){

        NSLog(@"%@", error);

    });

}

- (NSString *)mediaIDString
{
    if (self.images.count == 0) return nil;

    NSMutableString *string = [NSMutableString string];
    [string appendString:[[PhotoUploader sharedUploader] mediaIDStringFromLocalImage:self.images.firstObject]];

    if (self.images.count == 1) return string;

    for (int i = 1; i < self.images.count; ++i) {
        [string appendFormat:@",%@", [[PhotoUploader sharedUploader] mediaIDStringFromLocalImage:self.images[i]]];
    }

    return string;
}

#pragma mark - Handle PhotoUploaderNotification
- (void)photoUploadSuccess:(NSNotification *)notification
{
    LocalImage *localImage = notification.userInfo[@"localImage"];
    [self.uploadingImages removeObject:localImage];

    if (self.postPending && self.uploadingImages.count == 0) {
        self.postPending = NO;
        [self post];
    }

    [self.delegate postViewModel:self uploadImageCompleted:localImage];
}

- (void)photoUploadFailure:(NSNotification *)notification
{
    [self.delegate postViewModel:self
                     uploadImage:notification.userInfo[@"localImage"]
                          failed:notification.userInfo[@"error"]];
}

@end
