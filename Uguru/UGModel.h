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

#define API_BASE_URL @"http://testing.uguru.me/api/"
#define UGURU_AUTH_TOKEN @"X-UGURU-Token"
#define UGURU_KEYCHAIN_SERVICE @"uguru-keychain-service"
#define UGURU_KEYCHAIN_ACCOUNT @"uguru-keychain-account"
#define AUTO_LOGIN NO

typedef void (^UGSuccessBlock)(id responseObject);
typedef void (^UGFailBlock)(NSDictionary *errors);

@interface UGModel : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) NSArray *conversations;

+ (instancetype)sharedInstance;

- (void)signUp:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)login:(User *)user success:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;
- (void)getNotificationsWithSuccess:(UGSuccessBlock)successBlock fail:(UGFailBlock)failBlock;

@end
