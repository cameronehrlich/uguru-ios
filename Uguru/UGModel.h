//
//  UGModel.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <SSKeychain.h>
#import <MBProgressHUD.h>

#import "UGObject.h"
#import "User.h"
#import "Notification.h"
#import "Payment.h"
#import "Request.h"
#import "Conversation.h"
#import "Message.h"

#define API_BASE_URL           @"http://testing.uguru.me/api/"
#define UGURU_AUTH_TOKEN       @"X-UGURU-Token"
#define UGURU_KEYCHAIN_SERVICE @"uguru-keychain-service"
#define UGURU_KEYCHAIN_ACCOUNT @"uguru-keychain-account"
#define UGURU_APN_TOKEN        @"UGURU-APN-Token"

typedef void (^UGSuccessBlock)(id responseObject);
typedef void (^UGFailBlock)(id errorObject);

@interface UGModel : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) NSArray *conversations;

+ (instancetype)sharedInstance;

// User
- (void)signUp:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)login:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)logoutUserWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)getUserWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)updateUser:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;

// Messages
- (void)getAllConversationsWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)getMessagesForConversation:(Conversation *)convo success:(UGSuccessBlock)successBlock fail:(UGSuccessBlock)failBlock;
- (void)postMessage:(Message *)message success:(UGSuccessBlock)successBlock fail:(UGSuccessBlock)failBlock;


// Notifications
- (void)getAllNotificationsWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)getNotification:(NSNumber *)server_id withSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;

// Requests
- (void)postRequest:(Request *)request withSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)tutorAcceptRequest:(NSMutableDictionary *)params withSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;


@end
