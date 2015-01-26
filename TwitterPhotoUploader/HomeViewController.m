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

@interface HomeViewController () <
HomeModelDelegate,
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

    [[SDWebImageManager sharedManager] downloadImageWithURL:self.homeModel.loginUser.profileImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button addTarget:self action:@selector(accountButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = left;

    }];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    SimpleTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = [self.homeModel tweetAtIndex:indexPath.row];
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - User Interactions
- (IBAction)accountButtonTapped:(id)sender
{
    NSLog(@"hoge!!%@", sender);
    [self performSegueWithIdentifier:@"presentAccountSelection" sender:self];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSLog(@"%ld", sender.selectedSegmentIndex);
}

@end
