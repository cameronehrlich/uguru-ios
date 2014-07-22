//
//  UGUser.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "User.h"

@implementation User

-(NSString *)description
{
    return [NSString stringWithFormat:@"< User, %@, %@, %@, %@ >", self.server_id, self.name, self.email, self.auth_token];
}

@end
