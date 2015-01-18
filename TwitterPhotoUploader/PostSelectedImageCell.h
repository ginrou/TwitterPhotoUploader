//
//  PostSelectedImageCell.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PostSelectedImageCell : PhotoCollectionViewCell
- (void)startLoading;
- (void)stopLoading;
@end
