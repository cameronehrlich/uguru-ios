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


#pragma mark -
#pragma mark User
- (void)signUp:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager POST:@"sign_up" parameters:[user toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *newUser = [User fromDictionary:responseObject[@"user"]];
        
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
        User *newUser = [User fromDictionary:responseObject[@"user"]];
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

- (void)getUserWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    NSError *error;
    if (![SSKeychain passwordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT error:&error]) {
        if (error) {
            NSLog(@"Error in Get User: %@", error);
        }
        failBlock(@{@"Error": @"Authentication token not found"});
        return;
    }
    
    [self.requestManager GET:@"user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *returnedUser = [User fromDictionary:responseObject[@"user"]];
        self.user = returnedUser;
        successBlock(returnedUser);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get user failed.");
        failBlock(@{@"Error": @"Get user failed."});
    }];
}
- (void)updateUser:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager PUT:@"user"
                  parameters:[user toDictionary]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         User *updatedUser = [User fromDictionary:responseObject[@"user"]];
                         self.user = updatedUser;
                         successBlock(updatedUser);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"%@", error.debugDescription);
                         failBlock(@{});
                     }];
}

#pragma mark -
#pragma mark Notifications
- (void)getAllNotificationsWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager GET:@"notifications"
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
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

- (void)getNotification:(NSNumber *)server_id withSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager GET:[NSString stringWithFormat:@"notifications/%@", server_id]
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         Notification *notification = [Notification fromDictionary:responseObject[@"notification"]];
                         
                         // TODO : This is disgusting, like a switch statement but for retards...
                         NSString *responseType = responseObject[@"type"];
                         
                         // Set the type property on the Notification Instance
                         notification.type = responseType;
                         
                         if ([responseType isEqual:[NSNull null]]) {
                             successBlock(notification);
                             return;
                         }
                         
                         if ([responseType isEqualToString:@"student-request-help"])
                         {
                             notification.request = [Request fromDictionary:responseObject[@"request"]];
                         }
                         else if ([responseType isEqualToString:@"tutor-request-offer"])
                         {
                             notification.request = [Request fromDictionary:responseObject[@"request"]];
                         }
                         else if ([responseType isEqualToString:@"student-incoming-offer"])
                         {
                             notification.request = [Request fromDictionary:responseObject[@"request"]];
                         }
                         else if ([responseType isEqualToString:@"student-payment-approval"])
                         {
                             notification.payment = [Payment fromDictionary:responseObject[@"payment"]];
                         }
                         else if ([responseType isEqualToString:@"tutor-receive-payment"])
                         {
                             notification.payment = [Payment fromDictionary:responseObject[@"payment"]];
                         }else
                         {
                             NSLog(@"No action associated with this type of notification.");
                         }
                         
                         successBlock(notification);
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"%@", error);
                         failBlock(@{@"Errors": error.debugDescription});
                     }];
}

#pragma mark -
#pragma mark Messages

-(void)getAllConversationsWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager GET:@"conversations"
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         NSMutableArray *outputConvos = [NSMutableArray array];
                         
                         NSArray *_convos = responseObject[@"conversations"];
                         
                         for (NSDictionary *convoDict in _convos) {
                             Conversation *convo = [Conversation fromDictionary:convoDict];
                             [outputConvos addObject:convo];
                         }
                         
                         self.conversations = [outputConvos copy];
                         successBlock(self.conversations);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Failed to get all conversations");
                         failBlock(@{});
                     }];
}

@end
