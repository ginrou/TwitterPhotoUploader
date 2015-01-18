//
//  TwitterPhoto.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "TwitterPhoto.h"

@implementation TwitterPhoto

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        _mediaID = dict[@"id_str"];
        _mediaURL = [NSURL URLWithString:dict[@"media_url_https"]];
        _mediaURLorig = [NSURL URLWithString:[NSString stringWithFormat:@"%@:orig", dict[@"media_url_https"]]];
        _height = dict[@"sizes"][@"large"][@"h"];
        _width = dict[@"sizes"][@"large"][@"w"];
    }
    return self;
}

@end
