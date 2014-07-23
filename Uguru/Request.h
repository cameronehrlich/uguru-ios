//
//  Request.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"

@interface Request : UGObject

@property (nonatomic, strong) NSNumber *estimated_hourly;
@property (nonatomic, strong) NSNumber *connected_tutor;
@property (nonatomic, strong) NSNumber *student_estimated_hour;
@property (nonatomic, strong) NSNumber *time_estimate;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *professor;
@property (nonatomic, strong) NSNumber *urgency;
@property (nonatomic, strong) NSNumber *is_expired;

@end
