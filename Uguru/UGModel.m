//
//  UGModel.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGModel.h"

#define API_BASE_URL @"http://testing.uguru.me/api/"

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
    }
    return self;
}

@end
