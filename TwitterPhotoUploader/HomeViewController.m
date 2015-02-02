//
//  HomeViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/18.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "HomeViewController.h"

#import <SDWebImage/SDWebImageManager.h>

#import "HomeModel.h"
#import "SimpleTweetCell.h"

#import "ImageViewer.h"
#import "ImageViewerTweetDataSource.h"

@interface HomeViewController () <
HomeModelDelegate,
SimpleTweetCellDelegate,
ImageViewerDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) HomeModel *homeModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ImageViewerTweetDataSource *imageViewerCurrentDataSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.homeModel = [[HomeModel alloc] init];
    self.homeModel.delegate = self;
    [self.homeModel switchTimeLineType:HomeModelHomeTimeLine];

    [[SDWebImageManager sharedManager] downloadImageWithURL:self.homeModel.loginUser.profileImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button addTarget:self action:@selector(accountButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = left;

    }];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTweetCell_0img" bundle:nil]
         forCellReuseIdentifier:@"SimpleTweetCell_0img"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTweetCell_1img" bundle:nil]
         forCellReuseIdentifier:@"SimpleTweetCell_1img"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTweetCell_2img" bundle:nil]
         forCellReuseIdentifier:@"SimpleTweetCell_2img"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleTweetCell_4img" bundle:nil]
         forCellReuseIdentifier:@"SimpleTweetCell_4img"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)accountSelectionCompletedForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"First view return action invoked.");
}

- (void)imageViewerCloseButtonTapped:(ImageViewer *)imageViewer
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageViewerCurrentDataSource = nil;
}


#pragma mark - HomeModel Delegate
- (void)homeModel:(HomeModel *)sender retriveTweetsCompleted:(NSError *)error
{
    if (error == nil) {
        [self.tableView reloadData];
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeModel.tweetsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.homeModel tweetAtIndex:indexPath.row];
    SimpleTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_0img"];

    if (tweet.mediaList.count == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_1img"];
    }

    switch (tweet.mediaList.count) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_0img"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_1img"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_2img"];
            break;
        case 3:
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_4img"];
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTweetCell_0img"];
            break;
    }

    cell.tweet = tweet;
    cell.delegate = self;

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - CellDelegate

- (void)simpleTweetCell:(SimpleTweetCell *)sender imageTapped:(TwitterPhoto *)tappedPhoto
{
    ImageViewerTweetDataSource *dataSource = [[ImageViewerTweetDataSource alloc] init];
    dataSource.tweet = sender.tweet;

    ImageViewer *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewer"];
    imageViewer.dataSource = dataSource;
    imageViewer.delegate = self;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:imageViewer];

    [self presentViewController:nc animated:YES completion:nil];

    self.imageViewerCurrentDataSource = dataSource;
}

#pragma mark - User Interactions
- (IBAction)accountButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"presentAccountSelection" sender:self];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    HomeModelTimeLineType timelineType = sender.selectedSegmentIndex;
    [self.homeModel switchTimeLineType:timelineType];
}

@end
