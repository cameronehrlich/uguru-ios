//
//  UGUser.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : UGObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *auth_token;
@property (nonatomic, strong) NSString *apn_token;
@property (nonatomic, strong) NSString *recipient_id;
@property (nonatomic, strong) NSString *customer_id;
@property (nonatomic, strong) NSString *customer_last4;
@property (nonatomic, strong) NSString *image_url; // TODO : Implement on the server side!
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSMutableArray *skills;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSNumber *hkn_tutor;
@property (nonatomic, strong) NSNumber *ta_tutor;
@property (nonatomic, strong) NSNumber *la_tutor;
@property (nonatomic, strong) NSNumber *res_tutor;
@property (nonatomic, strong) NSNumber *slc_tutor;
@property (nonatomic, strong) NSNumber *is_a_tutor;
@property (nonatomic, strong) NSNumber *num_ratings;
@property (nonatomic, strong) NSNumber *email_notification;
@property (nonatomic, strong) NSNumber *push_notification;
@property (nonatomic, strong) NSNumber *total_earned;
@property (nonatomic, strong) NSNumber *balance;

@property (nonatomic, strong) NSDictionary *pending_ratings;

@end
