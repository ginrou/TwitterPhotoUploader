//
//  TwitterUserView.h
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TwitterUser.h"

@interface TwitterUserView : UIView
@property (nonatomic, strong) TwitterUser *user;
@end

/// アイコンの一辺の長さに対する角丸の半径の割合
FOUNDATION_EXPORT const CGFloat TwitterUserViewIconCornerRatio;