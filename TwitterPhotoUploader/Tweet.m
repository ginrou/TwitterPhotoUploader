//
//  Tweet.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        _ID = dict[@"id_str"];
        _user = [[TwitterUser alloc] initWithDict:dict[@"user"]];
        _text = dict[@"text"];

        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *media in dict[@"extended_entities"][@"media"]) {
            if (![media[@"type"] isEqualToString:@"photo"]) continue;
            [array addObject:[[TwitterPhoto alloc] initWithDict:media]];
        }
        if (array.count != 0) _mediaList = [NSArray arrayWithArray:array];

        static NSDateFormatter *dateFormatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            dateFormatter.dateStyle = NSDateFormatterLongStyle;
            dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
            dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss '+0000' yyyy";
        });

        _createdAt = [dateFormatter dateFromString:dict[@"created_at"]];

    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"@%@ : %@", self.user.screenName, self.text];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Tweet class]]) {
        return [self.ID isEqualToString:[(Tweet *)object ID]];
    }

    return [super isEqual:object];
}

@end
