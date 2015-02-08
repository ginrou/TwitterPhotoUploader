//
//  AccountSelectionViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/18.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "AccountSelectionViewController.h"

#import "TwitterAccount.h"
#import "TwitterClient.h"
#import "TwitterUser.h"
#import "TwitterUserView.h"
#import "AccountDataStore.h"

@interface AccountSelectionViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *accounts;
@property (weak, nonatomic) UITableViewCell *previousSelectedCell;
@end

@implementation AccountSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *accounts = [TwitterAccount accounts];
    NSAssert(accounts.count > 0, @"authorized account is zero");

    [TwitterClient getUsersShowForAccounts:accounts]
    .then(^(NSArray *responses){

        NSMutableArray *users = [NSMutableArray array];
        for (NSDictionary *json in responses) {
            TwitterUser *user = [[TwitterUser alloc] initWithDict:json];
            [users addObject:user];
        }

        self.accounts = users;
        [self.tableView reloadData];

    });

    self.tableView.estimatedRowHeight = 67;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TwitterUser *user = self.accounts[indexPath.row];

    [(TwitterUserView *)[cell viewWithTag:1] setUser:user];

    TwitterUser *defaultAccount = [AccountDataStore loadDefaultTwitterAccount];
    if ([user isEqual:defaultAccount]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.previousSelectedCell = cell;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.previousSelectedCell.accessoryType = UITableViewCellAccessoryNone;

    [AccountDataStore saveDefaultTwitterAccount:self.accounts[indexPath.row]];

    UITableViewCell *currentSelected = [tableView cellForRowAtIndexPath:indexPath];
    currentSelected.accessoryType = UITableViewCellAccessoryCheckmark;
    self.previousSelectedCell = currentSelected;

    [self performSegueWithIdentifier:@"accountSelectionCompleted"
                              sender:self];
}

@end
