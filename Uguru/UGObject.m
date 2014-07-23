//
//  UGObject.m
//  Uguru
//
//  Created by Cameron Ehrlich on 7/17/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGObject.h"
@import ObjectiveC;

@implementation UGObject

+ (instancetype)new
{
    return [[self alloc] init];
}

+ (instancetype)fromDictionary:(NSDictionary *)dict
{
    NSAssert(dict != nil, @"Can't form %@ with nil dict.", NSStringFromClass([self class]));
    id newObject = [[self alloc] init];
    for (NSString *key in [dict allKeys]) {
        if ([newObject respondsToSelector:NSSelectorFromString(key)] && ![@[@"description", @"id"] containsObject:key]) {
            [newObject setValue:dict[key] forKey:key];
        }
    }
    return newObject;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    // For super class properties
    objc_property_t *properties = class_copyPropertyList([self superclass], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:propName];
        id value = [self valueForKeyPath:propertyName] ? [self valueForKeyPath:propertyName] : [NSNull null];
        [body setObject:value forKey:propertyName];
    }
    
    // For self class properties
    properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:propName];
        id value = [self valueForKeyPath:propertyName] ? [self valueForKeyPath:propertyName] : [NSNull null];
        [body setObject:value forKey:propertyName];
    }
    free(properties);
    
    return body;
}

- (NSString *)description
{
    return [[self toDictionary] description];
}

@end
