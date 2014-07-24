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

- (void)logoutUserWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self setUser:nil];
    NSError *error;
    [SSKeychain deletePasswordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT error:&error];
    if (error) {
        NSLog(@"An error occured while trying to delete the keychain item containing the user's authtoken");
        failBlock(nil);
    }
    // TODO : any other cleanup work to clean up after a user logs out
    // Maybe you want to make a request to the server to alert it that the user has logged out...
    successBlock(nil);
}

- (void)getUserWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    NSError *error;
    if (![SSKeychain passwordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT error:&error]) {
        if (error) {
            NSLog(@"Error in Get User: %@", error);
        }
        failBlock(nil);
        return;
    }
    
    [self.requestManager GET:@"user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self errorsToHandle:responseObject]) {
            failBlock(nil);
            return;
        }
        
        User *returnedUser = [User fromDictionary:responseObject[@"user"]];
        self.user = returnedUser;
        successBlock(returnedUser);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get user failed.");
        failBlock(nil);
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

- (void)getMessagesForConversation:(Conversation *)convo success:(UGSuccessBlock)successBlock fail:(UGSuccessBlock)failBlock
{
    [self.requestManager GET:[NSString stringWithFormat:@"conversations/%@", convo.server_id]
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         if ([self errorsToHandle:responseObject]) {
                             failBlock(nil);
                             return;
                         }
                         
                         // TODO : ADD OTHER REAPONSES TO THE CONVERSATION MODEL
                         NSMutableArray *returnedMessages = [NSMutableArray array];
                         
                         convo.conversation_meeting_location = responseObject[@"conversation_meeting_location"];
                         convo.conversation_meeting_time = responseObject[@"conversation_meeting_time"];
                         
                         for (NSDictionary *messageDict in responseObject[@"messages"]) {
                             Message *newMessage = [Message fromDictionary:messageDict];
                             [returnedMessages addObject:newMessage];
                         }
                         convo.messages = [returnedMessages copy];
                         successBlock(convo);
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Failed to get messages for conversation.");
                         failBlock(nil);
                     }];
}

- (void)postMessage:(Message *)message success:(UGSuccessBlock)successBlock fail:(UGSuccessBlock)failBlock
{
    [self.requestManager POST:@"send_message" parameters:[message toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self errorsToHandle:responseObject]) {
            failBlock(responseObject[@"errors"]);
            return;
        }
        
        successBlock([Message fromDictionary:responseObject[@"message"]]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}

#pragma mark -
#pragma mark Requests

- (void)postRequest:(Request *)request withSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager POST:@"request"
                   parameters:[request toDictionary]
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          if ([self errorsToHandle:responseObject]) {
                              failBlock(responseObject[@"errors"]);
                              return;
                          }
                          
                          Request *request = [Request fromDictionary:responseObject[@"request"]];
                          successBlock(request);
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Failed in Post Request");
                          failBlock(nil);
                      }];
}

- (void)tutorAcceptRequest:(NSMutableDictionary *)params withSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock
{
    [self.requestManager PUT:@"tutor_accept"
                   parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if ([self errorsToHandle:responseObject]) {
                              failBlock(responseObject[@"errors"]);
                              return;
                          }
                          successBlock(params);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Failed in Post Request");
                          failBlock(nil);
                      }
     ];
    
}

#pragma mark -
#pragma mark Helper methods
- (BOOL)errorsToHandle:(NSDictionary *)responseObject
{
    if (responseObject[@"errors"]) {
        for (NSString *error in responseObject[@"errors"]) {
            
            // TODO : API should return an error code so we can switch on it
            
            if ([error isEqualToString:@"Invalid Token"]) {
                [self logoutUserWithSuccess:^(id responseObject) {
                    [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                                message:@"Your session has expired, please login again."
                                               delegate:nil
                                      cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                } fail:nil];
            }
            NSLog(@"API Error: %@", error);
        }
        return YES;
    }
    
    return NO;
}

@end
