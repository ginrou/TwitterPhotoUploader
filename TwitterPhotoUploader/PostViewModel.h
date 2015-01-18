//
//  PostViewModel.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import Foundation;

#import "LocalImage.h"
#import "TwitterUser.h"
#import "Tweet.h"

@protocol PostViewModelDelegate;

@interface PostViewModel : NSObject

@property (nonatomic, weak) id<PostViewModelDelegate> delegate;

/// ツイートの本文
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong, readonly) Tweet *postResult;

- (TwitterUser *)postUser;
- (void)post;

- (void)addImage:(LocalImage *)image;
- (LocalImage *)imageAtIndex:(NSInteger)index;
- (void)removeImage:(LocalImage *)image;
- (NSUInteger)imageCounts;
- (NSUInteger)indexOfImage:(LocalImage *)image;
- (BOOL)isUploading:(LocalImage *)image;

/// TODO
///- (NSUInteger)maximumImageCounts;

@end

@protocol PostViewModelDelegate <NSObject>
- (void)postViewModel:(PostViewModel *)sender updateImageCompleted:(LocalImage *)image;
- (void)postViewModel:(PostViewModel *)sender lookupUserCompleted:(TwitterUser *)lookuped;
- (void)postViewModel:(PostViewModel *)sender postCompleted:(Tweet *)tweet;
@end