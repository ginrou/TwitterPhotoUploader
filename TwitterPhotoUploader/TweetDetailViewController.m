//
//  TweetDetailViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TwitterUserView.h"

@interface TweetDetailViewController () <
UITableViewDataSource,
UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet TwitterUserView *userView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

// cells
@property (strong, nonatomic) NSArray *cells;
@property (strong, nonatomic) IBOutlet UITableViewCell *userCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *statusCell;

@end

@implementation TweetDetailViewController

//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil];
//    return [storyBoard instantiateInitialViewController];
//}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"hoge");
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.cells = @[self.userCell, self.statusCell];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    //self.statusLabel.text = self.tweet.text;

    self.userView.user = self.tweet.user;

}

- (void)renderCells
{
    self.userView.user = self.tweet.user;

    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cells[indexPath.row];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cells[indexPath.row];

    if (cell == self.statusCell) {
        self.statusLabel.text = @"";
        self.statusLabel.text = @"aaa\nbbb\nccc\nZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ00XXXXXXXXXX";
    }

    return cell;
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
