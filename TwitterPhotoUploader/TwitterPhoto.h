//
//  TwitterPhoto.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface TwitterPhoto : NSObject
@property (nonatomic, readonly) NSString *mediaID;
@property (nonatomic, readonly) NSURL *mediaURL;
@property (nonatomic, readonly) NSURL *mediaURLorig;
@property (nonatomic, readonly) NSNumber *height; // large
@property (nonatomic, readonly) NSNumber *width;  // large

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
