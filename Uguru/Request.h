//
//  Request.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"
#import "Calendar.h"

@interface Request : UGObject

+ (instancetype)new;

@property (nonatomic, strong) NSString *_description;
@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *professor_name;
@property (nonatomic, strong) NSNumber *urgency;
@property (nonatomic, strong) NSNumber *recurring;
@property (nonatomic, strong) NSNumber *estimated_hourly;
@property (nonatomic, strong) NSNumber *time_estimate;
@property (nonatomic, strong) NSNumber *student_estimated_hour;
@property (nonatomic, strong) NSString *location_name;
@property (nonatomic, strong) NSNumber *connected_tutor;
@property (nonatomic, strong) Calendar *calendar;

@end
