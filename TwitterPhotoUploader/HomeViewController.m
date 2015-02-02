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

@interface HomeViewController () <
HomeModelDelegate,
SimpleTweetCellDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) HomeModel *homeModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    [[SDWebImageManager sharedManager] downloadImageWithURL:tappedPhoto.mediaURLorig options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        if (!finished) return ;

        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 4; ++i) {
            [images addObject:[image copy]];
        }

        ImageViewer *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewer"];
        imageViewer.images = images;

        [self presentViewController:imageViewer animated:YES completion:nil];

    }];


}

#pragma mark - User Interactions
- (IBAction)accountButtonTapped:(id)sender
{
    NSLog(@"hoge!!%@", sender);
    [self performSegueWithIdentifier:@"presentAccountSelection" sender:self];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    HomeModelTimeLineType timelineType = sender.selectedSegmentIndex;
    [self.homeModel switchTimeLineType:timelineType];
}

@end
