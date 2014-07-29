//
//  Calendar.m
//  Uguru
//
//  Created by Samir Makhani on 7/28/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "Calendar.h"

@implementation Calendar

+ (instancetype)new
{
    Calendar *calendar = [[Calendar alloc] init];
    if (calendar) {
        calendar.num_hours_selected = 0;
        calendar.time_ranges = [[NSMutableArray alloc] initWithCapacity:7];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:0];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:1];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:2];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:3];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:4];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:5];
        [calendar.time_ranges insertObject:[[NSMutableArray alloc] init] atIndex:6];
    }
    return calendar;
}

@end
