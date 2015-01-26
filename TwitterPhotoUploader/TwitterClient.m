//
//  TwitterClient.m
//  TwitterPhotoUploader
//
//  Created by 武田 祐一 on 2015/01/11.
//  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.
//

#import "TwitterClient.h"

#import "SDNetworkActivityIndicator.h"

#import "TwitterAccount.h"

@interface SLRequest (PromiseKit)
- (void)performRequestWithFulFiller:(PMKPromiseFulfiller )fulfiller rejector:(PMKPromiseRejecter)rejecter;
@end

@implementation SLRequest (PromiseKit)
- (void)performRequestWithFulFiller:(PMKPromiseFulfiller)fulfiller rejector:(PMKPromiseRejecter)rejecter
{
    [[SDNetworkActivityIndicator sharedActivityIndicator] startActivity];
    [self performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        [[SDNetworkActivityIndicator sharedActivityIndicator] stopActivity];
        if (error) {
            rejecter(error);
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            fulfiller(PMKManifold(json, urlResponse));
        }
    }];
}
@end

@implementation TwitterClient
+ (SLRequest *)requestWithMethod:(SLRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(NSDictionary *)parameters
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/%@", endpoint]];
    return [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:method URL:url parameters:parameters];
}

+ (PMKPromise *)performRequset:(SLRequest *)request withGrantingToAccount:(ACAccount *)account
{
    return [TwitterAccount retriveAccessTokenForAccount:account]
    .then(^(ACAccount *grantedAccount){
        request.account = grantedAccount;
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            [request performRequestWithFulFiller:fulfill rejector:reject];
        }];
    });
}

+ (PMKPromise *)getHelpConfigurationForAccount:(ACAccount *)account
{
    SLRequest *request = [self requestWithMethod:SLRequestMethodGET
                                        endpoint:@"help/configuration.json"
                                      parameters:nil];

    return [self performRequset:request withGrantingToAccount:account];
}

+ (PMKPromise *)getUsersShowForAccount:(ACAccount *)account screenName:(NSString *)screenName
{
    SLRequest *request = [self requestWithMethod:SLRequestMethodGET
                                        endpoint:@"users/show.json"
                                      parameters:@{@"screen_name":screenName}];

    return [self performRequset:request withGrantingToAccount:account];
}

+ (PMKPromise *)getUsersShowForAccounts:(NSArray *)accounts
{
    NSMutableArray *promieses = [NSMutableArray array];
    for (ACAccount *account in accounts) {
        [promieses addObject:[self getUsersShowForAccount:account screenName:account.username]];
    }
    return [PMKPromise all:promieses];
}


+ (PMKPromise *)postMediaUploadForAccount:(ACAccount *)account
                                     data:(NSData *)imageData
                                 mimeType:(NSString *)mimeType
                                 filename:(NSString *)filename
{
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:[NSURL URLWithString:@"https://upload.twitter.com/1.1/media/upload.json"]
                                               parameters:nil];
    [request addMultipartData:imageData
                     withName:@"media"
                         type:mimeType
                     filename:filename];
    return [self performRequset:request withGrantingToAccount:account];
}

+ (PMKPromise *)postStatusUpdateForAccount:(ACAccount *)account
                                    status:(NSString *)status
                                  mediaIDs:(NSString *)mediaIDs
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = status;
    if (mediaIDs) params[@"media_ids"] = mediaIDs;

    SLRequest *request = [self requestWithMethod:SLRequestMethodPOST
                                        endpoint:@"statuses/update.json"
                                      parameters:params];
    return [self performRequset:request withGrantingToAccount:account];
}

+ (PMKPromise *)getStatusesUserTimelineForAccount:(ACAccount *)account
                                       screenName:(NSString *)screenName
{
    SLRequest *request = [self requestWithMethod:SLRequestMethodGET
                                        endpoint:@"statuses/user_timeline.json"
                                      parameters:@{@"screen_name":screenName}];

    return [self performRequset:request withGrantingToAccount:account];
}

+ (PMKPromise *)getStatusesHomeTimelineForAccount:(ACAccount *)account
                                       screenName:(NSString *)screenName
{
    SLRequest *request = [self requestWithMethod:SLRequestMethodGET
                                        endpoint:@"statuses/home_timeline.json"
                                      parameters:nil];

    return [self performRequset:request withGrantingToAccount:account];
}

@end
