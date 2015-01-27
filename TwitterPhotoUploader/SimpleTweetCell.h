//
//  SimpleTweetCell.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/19.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@protocol SimpleTweetCellDelegate;

@interface SimpleTweetCell : UITableViewCell
@property (nonatomic, weak) id<SimpleTweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;
@end

@protocol SimpleTweetCellDelegate <NSObject>
- (void)simpleTweetCell:(SimpleTweetCell *)sender imageTapped:(TwitterPhoto *)tappedPhoto;
@end