//
//  Conversation.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/22/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"

@interface Conversation : UGObject

@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *last_message;
@property (nonatomic, strong) NSString *last_message_time;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *read;

@end
