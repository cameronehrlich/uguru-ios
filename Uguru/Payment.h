//
//  Payment.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"

@interface Payment : UGObject

@property (nonatomic, strong) NSNumber *student_d;
@property (nonatomic, strong) NSNumber *skill_id;
@property (nonatomic, strong) NSNumber *time_amount;
@property (nonatomic, strong) NSNumber *tutor_rate;

@end
