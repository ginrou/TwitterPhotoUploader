//
//  TwitterUser.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "TwitterUser.h"

@implementation TwitterUser
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        _name = dict[@"name"];
        _screenName = dict[@"screen_name"];
        _userID = dict[@"id_str"];
        _profileImageURL = [NSURL URLWithString:dict[@"profile_image_url_https"]];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[TwitterUser class]] == NO) return NO;
    return [self.name isEqual:[(TwitterUser *)object name]];
}

@end
