//
//  Calendar.h
//  Uguru
//
//  Created by Samir Makhani on 7/28/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "UGObject.h"
#import "Request.h"

@class Request;

@interface Calendar : UGObject
@property (nonatomic) NSNumber *length_of_session;
@property (nonatomic) int num_hours_selected;
@property (nonatomic, strong) NSMutableArray *time_ranges;
@property (nonatomic, strong) Request *request;


+ (instancetype)new;

@end
