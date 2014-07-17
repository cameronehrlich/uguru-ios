//
//  UGObject.h
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGObject : NSObject

@property (nonatomic, strong) NSNumber *server_id;

- (NSDictionary *)toDictionary;

@end
