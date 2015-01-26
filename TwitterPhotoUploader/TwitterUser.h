//
//  TwitterUser.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterUser : NSObject
@property (nonatomic, readonly) NSString *screenName;
@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSURL *profileImageURL;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
