//
//  Request.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "Request.h"

@implementation Request

+ (instancetype)new {
    Request *request = [[Request alloc] init];
    if (request) {
        request.time_estimate = @2;
        request.student_estimated_hour = @15;
    }
    return request;
}

@end
