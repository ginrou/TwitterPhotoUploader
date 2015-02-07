//
//  PostSelectedImageCell.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@protocol PostSelectedImageCellDelegate;

@interface PostSelectedImageCell : PhotoCollectionViewCell
@property (nonatomic, weak) id<PostSelectedImageCellDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;
@property (getter=caution, setter=setCaution:) BOOL caution;
@end

@protocol PostSelectedImageCellDelegate <NSObject>
- (void)postSelectedImageCellCancelButtonTapped:(PostSelectedImageCell *)cell;
@end