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

+ (instancetype)new;

+ (instancetype)fromDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end
