//
//  PostSelectedImageCell.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PostSelectedImageCell.h"

@interface PostSelectedImageCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *cautionIcon;

@end

@implementation PostSelectedImageCell
- (void)startLoading
{
    [self.activityIndicator startAnimating];
    self.highlightOverlay.hidden = NO;
}

- (void)stopLoading
{
    [self.activityIndicator stopAnimating];
    self.highlightOverlay.hidden = !self.highlighted;
}

- (void)setCaution:(BOOL)caution
{
    self.cautionIcon.hidden = !caution;
}

- (BOOL)caution
{
    return !self.cautionIcon.hidden;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    if (highlighted || self.activityIndicator.isAnimating) {
        self.highlightOverlay.hidden = NO;
    } else {
        self.highlightOverlay.hidden = YES;
    }
}
- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate postSelectedImageCellCancelButtonTapped:self];
}

@end
