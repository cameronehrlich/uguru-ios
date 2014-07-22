//
//  UGModel.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGModel.h"

@implementation UGModel

+ (instancetype)sharedInstance
{
    static UGModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UGModel alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
        [self.requestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [[self.requestManager responseSerializer] setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
        if ([SSKeychain passwordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT]) {
            [[self.requestManager requestSerializer] setValue:[SSKeychain passwordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT] forHTTPHeaderField:UGURU_AUTH_TOKEN];
        }
    }
    return self;
}

- (void)signUp:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager POST:@"sign_up" parameters:[user toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *newUser = [User new];
        newUser.name = responseObject[@"user"][@"name"];
        newUser.email = responseObject[@"user"][@"email"];
        newUser.auth_token = responseObject[@"user"][@"auth_token"];
        
        NSError *error;
        [SSKeychain setPassword:newUser.auth_token forService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT error:&error];
        if (error) {
            NSLog(@"Keychain Error :%@", error.debugDescription);
            failBlock(@{@"Error": error.debugDescription});
            return;
        }
        [[self.requestManager requestSerializer] setValue:newUser.auth_token forHTTPHeaderField:UGURU_AUTH_TOKEN];
        self.user = user;
        successBlock(newUser);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(@{@"Error": error.debugDescription});
    }];
}

- (void)login:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager POST:@"sign_in" parameters:[user toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *newUser = [User new];
        newUser.name = responseObject[@"user"][@"name"];
        newUser.email = responseObject[@"user"][@"email"];
        newUser.auth_token = responseObject[@"user"][@"auth_token"];
        
        NSError *error;
        [SSKeychain setPassword:newUser.auth_token forService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT error:&error];
        
        if (error) {
            NSLog(@"Keychain Error :%@", error.debugDescription);
            failBlock(@{@"Error": error.debugDescription});
            return;
        }
        [[self.requestManager requestSerializer] setValue:newUser.auth_token forHTTPHeaderField:UGURU_AUTH_TOKEN];
        self.user = user;
        successBlock(newUser);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(@{@"Error": error.debugDescription});
    }];
}

- (void)getNotificationsWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager GET:@"notifications" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *notifications = responseObject[@"notifications"];

        NSMutableArray *output = [NSMutableArray array];
        
        for (NSDictionary *notificationDict in notifications) {
            Notification *notification = [Notification fromDictionary:notificationDict];
            [output addObject:notification];
        }
        
        self.notifications = [output copy];
        
        successBlock(self.notifications);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failBlock(@{@"Errors": error.debugDescription});
    }];
}
@end
