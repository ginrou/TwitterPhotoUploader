//
//  Tweet.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TwitterUser.h"
#import "TwitterPhoto.h"

@interface Tweet : NSObject
@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) TwitterUser *user;
@property (nonatomic, readonly) NSArray *mediaList;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
