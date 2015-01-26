//
//  SimpleTweetCell.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/19.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "SimpleTweetCell.h"
#import "TwitterUserView.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface SimpleTweetCell ()
@property (weak, nonatomic) IBOutlet TwitterUserView *userView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imageButtons;


@end

@implementation SimpleTweetCell

- (void)awakeFromNib {

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

    for (int i = 0; i < self.imageButtons.count; ++i) {
        UIButton *imageButton = self.imageButtons[i];
        TwitterPhoto *photo = self.tweet.mediaList[i];
        [imageButton sd_setBackgroundImageWithURL:photo.mediaURLorig
                                         forState:UIControlStateNormal];
    }

}
- (IBAction)imageButtonTapped:(id)sender {
    NSLog(@"%@", sender);
}

@end
