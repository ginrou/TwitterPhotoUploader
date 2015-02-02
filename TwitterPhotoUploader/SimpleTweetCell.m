//
//  SimpleTweetCell.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/19.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import QuartzCore;

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
    [super awakeFromNib];

    for (UIButton *imageButton in self.imageButtons) {
        imageButton.layer.borderWidth = 1.0;
        imageButton.layer.borderColor = [[UIColor whiteColor] CGColor];

        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        for (UIView *view in imageButton.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                view.contentMode = UIViewContentModeScaleAspectFill;
            }
        }
    }
}

- (void)setTweet:(Tweet *)tweet
{
    if (tweet != _tweet) {
        _tweet = tweet;

        self.userView.user = tweet.user;
        self.bodyLabel.text = tweet.text;

        for (int i = 0; i < self.imageButtons.count; ++i) {
            UIButton *imageButton = self.imageButtons[i];

            if (self.tweet.mediaList.count > i) {
                imageButton.hidden = NO;
                TwitterPhoto *photo = self.tweet.mediaList[i];
                [imageButton sd_setImageWithURL:photo.mediaURLorig
                                       forState:UIControlStateNormal];
            } else {
                imageButton.hidden = YES;
            }

        }

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
}

- (IBAction)imageButtonTapped:(id)sender {
    NSInteger selectedIndex = [self.imageButtons indexOfObject:sender];
    if (selectedIndex != NSNotFound) {
        TwitterPhoto *photo = self.tweet.mediaList[selectedIndex];
        [self.delegate simpleTweetCell:self imageTapped:photo];
    }
    
}

@end
