//
//  WelcomeViewController.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

@import Photos;

#import "WelcomeViewController.h"

#import "TwitterAccount.h"
#import "TwitterUserView.h"
#import "AccountDataStore.h"
#import "TwitterClient.h"

@interface WelcomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *useTwitterButton;
@property (weak, nonatomic) IBOutlet UILabel *twitterStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *usePhotoButton;
@property (weak, nonatomic) IBOutlet UILabel *photoStatusLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *accounts;
@property (assign, nonatomic) NSInteger previousSelectedIndex;

@property (copy, nonatomic) void (^onComplete)(BOOL rootViewControllerChanged);
@end

@implementation WelcomeViewController

+ (void)blockUntilAllServiceReady:(UIWindow *)window onComplete:(void (^)(BOOL rootViewControllerChanged))onComplete
{
    if ([[self class] isAllServiceReady]) {
        onComplete(NO);
        return;
    }

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Welcome" bundle:nil];
    WelcomeViewController *welcome = [storyBoard instantiateInitialViewController];
    welcome.onComplete = onComplete;
    window.rootViewController = welcome;
}

+ (BOOL)isAllServiceReady
{
    if ([TwitterAccount isGrantedForService] == NO) return NO;
    if ([TwitterAccount isAccountRegistered] == NO) return NO;
    if ([AccountDataStore defaultAccountSet] == NO) return NO;
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) return NO;

    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.useTwitterButton.enabled = ![TwitterAccount isGrantedForService];
    self.usePhotoButton.enabled = [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined;
    [self updateTwitterStatusLabel];
    [self updatePhotoStatusLabel];
    [self loadTwitterAccounts];

    if ([TwitterAccount isGrantedForService]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(twitterAccountStatusChanged:)
                                                     name:ACAccountStoreDidChangeNotification
                                                   object:nil];
    }
}

- (void)check
{
    if ([[self class] isAllServiceReady]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.onComplete(YES);
            weakSelf.onComplete = nil;
        });
    }
}

- (void)updateTwitterStatusLabel
{
    if ([TwitterAccount isGrantedForService] == NO) {
        self.twitterStatusLabel.text = @"";
    } else if ([TwitterAccount isAccountRegistered] == NO) {
        self.twitterStatusLabel.text = @"アカウントが登録されていません。設定アプリから設定してください。";
    } else {
        self.twitterStatusLabel.text = @"OK";
    }
}

- (void)updatePhotoStatusLabel
{
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            self.photoStatusLabel.text = @"OK";
            break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            self.photoStatusLabel.text = @"設定できていません。設定アプリから設定してください。";
            break;

        case PHAuthorizationStatusNotDetermined:
            self.photoStatusLabel.text = @"";
            break;
    }
}

- (IBAction)twitterButtonTapped:(id)sender {
    self.useTwitterButton.enabled = NO;

    [TwitterAccount getGrantForService]
    .then(^(id arg){
        [self updateTwitterStatusLabel];
        [self check];
        [self loadTwitterAccounts];
    });
}

- (IBAction)photoButtonTapped:(id)sender {
    self.usePhotoButton.enabled = NO;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updatePhotoStatusLabel];
            [self check];
        });
    }];
}

- (void)twitterAccountStatusChanged:(NSNotification *)noti
{
    [self updateTwitterStatusLabel];
    [self check];
    [self loadTwitterAccounts];
}

- (void)loadTwitterAccounts
{
    NSArray *accounts = [TwitterAccount accounts];
    if (accounts.count == 0) return;

    [TwitterClient getUsersShowForAccounts:accounts]
    .then(^(NSArray *responses){

        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *json in responses) {
            TwitterUser *user = [[TwitterUser alloc] initWithDict:json];
            [array addObject:user];
        }

        self.accounts = array;
        [self.tableView reloadData];
    });
}

#pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TwitterUserView *userView = (TwitterUserView *)[cell.contentView viewWithTag:1];
    [userView setUser:self.accounts[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:indexPath];
    previousCell.accessoryType = UITableViewCellAccessoryNone;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    self.previousSelectedIndex = indexPath.row;
    [AccountDataStore saveDefaultTwitterAccount:self.accounts[indexPath.row]];
    [self check];
}

@end
