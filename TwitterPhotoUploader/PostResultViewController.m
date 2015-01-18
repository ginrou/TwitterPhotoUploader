//
//  PostResultViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/12.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "PostResultViewController.h"
#import "TweetDetailViewController.h"

#import "TwitterUserView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TwitterUserCell : UITableViewCell
@property (nonatomic, weak) IBOutlet TwitterUserView *userView;
@end

@implementation TwitterUserCell
@end

@interface TwitterStatusCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation TwitterStatusCell
@end

@interface TwitterPhotoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) TwitterPhoto *photo;
@end

@implementation TwitterPhotoCell
- (void)setPhoto:(TwitterPhoto *)photo
{
    if (_photo != photo) {
        _photo = photo;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.photoView sd_setImageWithURL:self.photo.mediaURL];
}

@end

@interface PostResultViewController () <
UITableViewDataSource,
UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cells;
@end

@implementation PostResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    NSMutableArray *cellData = [NSMutableArray array];
    [cellData addObject:@{@"key": @"userCell", @"data": self.postResult.user}];
    [cellData addObject:@{@"key": @"statusCell", @"data": self.postResult.text}];
    for (TwitterPhoto *photo in self.postResult.mediaList) {
        [cellData addObject:@{@"key": @"photoCell", @"data": photo}];
    }
    self.cells = cellData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.cells[indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:data[@"key"]];

    if ([cell isKindOfClass:[TwitterUserCell class]]) {
        [(TwitterUserCell *)cell userView].user = data[@"data"];
    } else if ([cell isKindOfClass:[TwitterStatusCell class]]) {
        TwitterStatusCell *statusCell = (TwitterStatusCell *)cell;
        statusCell.textView.text = @"";
        statusCell.textView.text = data[@"data"];
    } else {
        [(TwitterPhotoCell *)cell setPhoto:data[@"data"]];
    }

    return cell;
}

@end
