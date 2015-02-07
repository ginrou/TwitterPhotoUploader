//
//  ImageViewer.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/27.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "ImageViewer.h"

@protocol ImageViewerCellDelegate;

@interface ImageViewerCell : UICollectionViewCell <UIScrollViewDelegate>
@property (weak, nonatomic) id<ImageViewerCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *labelBackground;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
/// 非同期でデータを取ってきた時に不整合が起きるのを防ぐためのキー
@property (assign, nonatomic) NSUInteger rowKey;

- (void)setImage:(UIImage *)image description:(NSString *)description actionButtonTitle:(NSString *)actionButtonTitle;

@end

@protocol ImageViewerCellDelegate <NSObject>
- (void)imageViewerCellActionButtonTapped:(ImageViewerCell *)cell;
@end

@implementation ImageViewerCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(singleTapped:)];
    singleTap.numberOfTapsRequired = 1;

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(doubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];

    [self.scrollView addGestureRecognizer:singleTap];
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)singleTapped:(UITapGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.labelBackground.alpha = fabsf(1.0 - self.labelBackground.alpha);
    }];
}

- (void)doubleTapped:(UITapGestureRecognizer *)sender
{
    if (fabs( self.scrollView.zoomScale - self.scrollView.maximumZoomScale) < FLT_EPSILON) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        [self singleTapped:nil];
    } else {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}

- (IBAction)actionButtonTapped:(id)sender {
    [self.delegate imageViewerCellActionButtonTapped:self];
}

- (void)setImage:(UIImage *)image
     description:(NSString *)description
actionButtonTitle:(NSString *)actionButtonTitle
{
    self.imageView.image = image;
    self.label.text = description;
    self.labelBackground.alpha = 1.0;

    self.actionButton.hidden = (actionButtonTitle == nil);
    [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];

    [self setNeedsLayout];
}

@end

@interface ImageViewer ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
ImageViewerCellDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ImageViewer

static NSString * const reuseIdentifier = @"ImageViewerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Rotation
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    NSIndexPath *indexPath = self.collectionView.indexPathsForVisibleItems.firstObject;
    [self.collectionView.collectionViewLayout invalidateLayout];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
    });
}

#pragma mark public
- (void)updateAtIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource imageViewerNumberOfImages:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                      forIndexPath:indexPath];
    cell.rowKey = indexPath.row;
    cell.delegate = self;

    [self.dataSource imageViewer:self contentsAtIndex:indexPath.row callback:^(NSInteger rowKey, NSString *description, NSString *actionButtonTitle, UIImage *image) {
        if (cell.rowKey != rowKey) return;
        [cell setImage:image description:description actionButtonTitle:actionButtonTitle];
        [cell layoutIfNeeded];
    }];

    return cell;
}

#pragma mark <UIImageCellDelegate>
- (void)imageViewerCellActionButtonTapped:(ImageViewerCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(imageViewer:actionButtonTappedAtIndex:)]) {
        [self.delegate imageViewer:self actionButtonTappedAtIndex:indexPath.row];
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size;
}


/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }

 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }

 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

 }
 */

- (IBAction)closeButtonTapped:(id)sender {
    [self.delegate imageViewerCloseButtonTapped:self];
}

@end
