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

@end
