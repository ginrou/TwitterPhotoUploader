//
//  PhotoSelectViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/09.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PhotoSelectViewController.h"

#import "AlbumPhotoDataSource.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoSelectViewController () <
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) AlbumPhotoDataSource *photoDataSource;
@end

static NSString *const kCellKey = @"cell";

@implementation PhotoSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoDataSource = [AlbumPhotoDataSource new];

    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:kCellKey];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoDataSource.numberOfPhotos;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellKey
                                                                              forIndexPath:indexPath];
    cell.image = [self.photoDataSource imageAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) { // iPad
        return CGSizeMake(100, 100);
    } else { // iPhone
        return CGSizeMake(65, 65);
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if ([self.photoDataSource isImageSelected:cell.image]) {
        [self.photoDataSource deselectImage:cell.image];
    } else {
        [self.photoDataSource selectImage:cell.image];
        [self.delegate photoSelectViewControler:self
                                  imageSelected:cell.image];
    }
}

#pragma mark - PhotoSelectionViewControllerProtocol
- (void)imageDeselcted:(LocalImage *)image
{
    [self.photoDataSource deselectImage:image];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
