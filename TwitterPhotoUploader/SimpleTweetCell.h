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

/**
 * @class SimpleTweetCell
 * HomeViewControllerでツイートを簡略表示するときに用いるセル
 * 対応するxibはそれぞれ
 * SimepleTweetCell_0img.xib, SimepleTweetCell_1img.xib,
 * SimepleTweetCell_2img.xib, SimepleTweetCell_4img.xib
 * の４つ。これ画像枚数によってレイアウトを変更するのを避けるためである。
 */
@interface SimpleTweetCell : UITableViewCell
@property (nonatomic, weak) id<SimpleTweetCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;
@end

@protocol SimpleTweetCellDelegate <NSObject>
- (void)simpleTweetCell:(SimpleTweetCell *)sender imageTapped:(TwitterPhoto *)tappedPhoto;
@end