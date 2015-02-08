//
//  AlbumPhotoDataSource.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "AlbumPhotoDataSource.h"

@import Photos;

@interface AlbumPhotoDataSource ()
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@end

@implementation AlbumPhotoDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {

        _images = [NSMutableArray array];
        _selectedImages = [NSMutableArray array];

        PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                              options:nil];

        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *assetsResult = [PHAsset fetchAssetsInAssetCollection:fetchResult.firstObject
                                                                    options:options];

        [assetsResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {

            LocalImage *image = [LocalImage new];
            image.asset = asset;
            [_images addObject:image];
        }];

    }
    return self;
}

- (NSUInteger)numberOfPhotos
{
    return self.images.count;
}

- (UIImage *)imageAtIndex:(NSUInteger)index
{
    return self.images[index];
}

- (void)selectImage:(LocalImage *)image
{
    // TODO: 引数のimageが _images に含まれていることを確認する
    // TODO: 引数のimageが _selectedImages に含まれていないことを確認する
    [self.selectedImages addObject:image];
}

- (BOOL)isImageSelected:(LocalImage *)image
{
    return [self.selectedImages containsObject:image];
}

- (void)deselectImage:(LocalImage *)image
{
    // TODO: 引数のimageが _images に含まれていることを確認する
    // TODO: 引数のimageが _selectedImages に含まれているを確認する
    [self.selectedImages removeObject:image];
}

@end
