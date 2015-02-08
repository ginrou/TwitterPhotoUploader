//
//  TwitterUserView.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import QuartzCore;

#import "TwitterUserView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TwitterUserView ()
@property (nonatomic, strong) IBOutlet UILabel *screenNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@end

const CGFloat TwitterUserViewIconCornerRatio = 0.15;

@implementation TwitterUserView

- (void)setUser:(TwitterUser *)user
{
    if (_user != user) {

        [self willChangeValueForKey:@"user"];
        _user = user;
        [self didChangeValueForKey:@"user"];

        [self setNeedsLayout];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    [self.iconImageView sd_setImageWithURL:self.user.profileImageURL];

    [self.iconImageView.layer setCornerRadius:self.iconImageView.bounds.size.height * TwitterUserViewIconCornerRatio];
    [self.iconImageView.layer setMasksToBounds:YES];
}

@end
