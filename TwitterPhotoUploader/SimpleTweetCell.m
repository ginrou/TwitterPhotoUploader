//
//  SimpleTweetCell.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/19.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "SimpleTweetCell.h"
#import "TwitterUserView.h"

@interface SimpleTweetCell ()
@property (weak, nonatomic) IBOutlet TwitterUserView *userView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation SimpleTweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTweet:(Tweet *)tweet
{
    if (tweet != _tweet) {
        _tweet = tweet;
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userView.user = self.tweet.user;
    self.bodyLabel.text = self.tweet.text;
    //self.imageHeightConstraint.constant = 70 * (1+self.tweet.mediaList.count);

}

@end
