//
//  PhotoCollectionViewCell.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) PHImageRequestID thumbRequestID;

@end

// 適当な定数がないのでとりあえずinvalidをいれておく
// このIDの場合は読み込みなどを行わない
static const PHImageRequestID kNotLoadingID = PHInvalidImageRequestID;

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    self.thumbRequestID = kNotLoadingID;
}

- (void)setImage:(LocalImage *)image
{
    if (image != _image) {

        if (self.thumbRequestID != kNotLoadingID) {
            [[PHCachingImageManager defaultManager] cancelImageRequest:self.thumbRequestID];
        }

        self.highlightOverlay.hidden = YES;

        // 実体はここで交代する
        _image = image;

        self.thumbRequestID = [[PHCachingImageManager defaultManager]
         requestImageForAsset:image.asset
         targetSize:self.imageView.bounds.size
         contentMode:PHImageContentModeAspectFill
         options:0
         resultHandler:^(UIImage *result, NSDictionary *info) {
             self.thumbRequestID = kNotLoadingID;
             self.imageView.image = result;
         }];
        
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.highlightOverlay.hidden = !highlighted;
}

@end
