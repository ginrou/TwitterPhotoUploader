//
//  ImageViewerTweetDataSource.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/02/02.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tweet.h"
#import "ImageViewer.h"

@interface ImageViewerTweetDataSource : NSObject <ImageViewerDataSource>
@property (nonatomic, strong) Tweet *tweet;
@end
