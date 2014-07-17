//
//  UGModel.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "UGObject.h"
#import "User.h"

@interface UGModel : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

+ (instancetype)sharedInstance;

@end
