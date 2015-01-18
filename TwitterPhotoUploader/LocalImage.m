//
//  LocalImage.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "LocalImage.h"

@implementation LocalImage

@end

@implementation NSObject (HashKey)

- (NSString *)hashKey
{
    return [NSString stringWithFormat:@"%p", self];
}

@end