//
//  Notification.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/21/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"
#import "Payment.h"
#import "Request.h"

@interface Notification : UGObject

@property (nonatomic, strong) NSString *feed_message;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *time_created;
@property (nonatomic, strong) NSString *time_read;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) Payment  *payment;
@property (nonatomic, strong) Request  *request;

@end
