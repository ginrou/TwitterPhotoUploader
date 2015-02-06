//
//  PostViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/10.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PostViewController.h"
#import "PostViewModel.h"
#import "PhotoSelectionNavigationViewController.h"
#import "PostSelectedImageCell.h"
#import "PostResultViewController.h"

#import "TwitterUserView.h"

#import "ImageViewer.h"
#import "ImageViewerLocalImageDataSource.h"

@interface PostViewController () <
UICollectionViewDataSource,
UICollectionViewDelegate,
UITextViewDelegate,
PostViewModelDelegate,
PhotoSelectionNavigationDelegate,
ImageViewerDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *selectedPhotoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *charCountsLabel;
@property (weak, nonatomic) IBOutlet TwitterUserView *postUserView;
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardBottomConstraint;

@property (nonatomic) PostViewModel *viewModel;

@property (nonatomic) ImageViewerLocalImageDataSource *currentImageViewerDataSource;

@end

static NSString *const kCellName = @"PostSelectedImageCell";
static const CGFloat kSelectedPhotoCollectionViewHeight = 65.f;

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [PostViewModel new];
    self.viewModel.delegate = self;

    [self.selectedPhotoCollectionView registerNib:[UINib nibWithNibName:@"PostSelectedImageCell" bundle:nil]
                       forCellWithReuseIdentifier:kCellName];
    [self.photoCollectionViewHeightConstraint setConstant:0];

    self.keyboardToolbar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisapper:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"embedPhotoSelection"]) {
        PhotoSelectionNavigationViewController *embed = segue.destinationViewController;
        embed.photoSelectionDelegate = self;
    }

    if ([segue.identifier isEqualToString:@"postCompleted"]) {
        PostResultViewController *postResult = segue.destinationViewController;
        postResult.postResult = self.viewModel.postResult;
    }
}

#pragma mark - ImageViewerDelegate
- (void)imageViewerCloseButtonTapped:(ImageViewer *)imageViewer
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.currentImageViewerDataSource = nil;
    }];
}

#pragma mark - PostViewModelDelegate
- (void)postViewModel:(PostViewModel *)sender lookupUserCompleted:(TwitterUser *)lookuped
{
    self.postUserView.user = lookuped;
}

- (void)postViewModel:(PostViewModel *)sender updateImageCompleted:(LocalImage *)image
{
    NSInteger index = [sender indexOfImage:image];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    PostSelectedImageCell *cell = (PostSelectedImageCell *)[self.selectedPhotoCollectionView cellForItemAtIndexPath:indexPath];
    [cell stopLoading];
}

- (void)postViewModel:(PostViewModel *)sender postCompleted:(Tweet *)tweet
{
    [self.delegate postViewController:self postCompleted:tweet];
}

#pragma mark - PhotoSelectionNavigationDelegate
- (void)photoSelectionNavigationViewController:(PhotoSelectionNavigationViewController *)sender
                                 imageSelected:(LocalImage *)image
{
    [self.viewModel addImage:image];
    [self.photoCollectionViewHeightConstraint setConstant:kSelectedPhotoCollectionViewHeight];
    [self.selectedPhotoCollectionView performBatchUpdates:^{
        NSUInteger index = [self.viewModel indexOfImage:image];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.selectedPhotoCollectionView insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - UICollectionView DataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.imageCounts;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostSelectedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellName
                                                                            forIndexPath:indexPath];
    LocalImage *image = [self.viewModel imageAtIndex:indexPath.row];
    cell.image = image;

    [self.viewModel isUploading:image] ? [cell startLoading] : [cell stopLoading];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewer *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewer"];
    ImageViewerLocalImageDataSource *dataSource = [ImageViewerLocalImageDataSource new];
    dataSource.imageViewer = imageViewer;
    dataSource.localImages = self.viewModel.images;

    imageViewer.dataSource = dataSource;
    imageViewer.delegate = self;
    [self presentViewController:imageViewer animated:YES completion:nil];

    self.currentImageViewerDataSource = dataSource;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.charCountsLabel.text = [NSString stringWithFormat:@"%ld", (long)textView.text.length];
    self.viewModel.status = textView.text;
}

#pragma mark - Keyboard Notification
- (void)keyboardWillAppear:(NSNotification *)notification
{
    self.keyboardToolbar.hidden = NO;
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSValue *dstRectValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect dstRect = [dstRectValue CGRectValue];
    CGRect converted = [self.view convertRect:dstRect toView:nil];

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    self.keyboardBottomConstraint.constant = converted.size.height;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidDisapper:(NSNotification *)notification
{
    self.keyboardToolbar.hidden = YES;
}

#pragma mark - User Interactions
- (IBAction)tweetButtonTapped:(id)sender
{
    [self.viewModel post];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate postViewControllerDidCanceled:self];

}
- (IBAction)closeKeyboardButtonTapped:(id)sender {
    [self.textView resignFirstResponder];
}

@end
