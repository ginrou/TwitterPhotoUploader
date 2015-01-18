//
//  PhotoCollectionViewCell.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalImage.h"


@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic) LocalImage *image;

// Only used from subclass
@property (weak, nonatomic) IBOutlet UIView *highlightOverlay;

@end
