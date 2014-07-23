//
//  Message.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/23/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"

@interface Message : UGObject

@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *sender_name;
@property (nonatomic, strong) NSString *receiver_name;
@property (nonatomic, strong) NSNumber *sender_server_id;
@property (nonatomic, strong) NSNumber *receiver_server_id;
@property (nonatomic, strong) NSDate *write_time;

@end
