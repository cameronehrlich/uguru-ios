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
    
    NSArray *reservedSymbols = @[@"description", @"id"];
    
    id newObject = [[self alloc] init];
    for (NSString *key in [dict allKeys]) {
        
        if ([newObject respondsToSelector:NSSelectorFromString(key)]) {
            if ([reservedSymbols containsObject:key]) {
                NSLog(@"Tried to map to an Objc reserved key path. BAD! ( %@ -> %@ )", NSStringFromClass([self class]), key);
                continue;
            }
            
            if ([dict[key] isEqual:[NSNull null]]) {
                // DON'T set properties to [NSNull null] object, leave them as nil
                continue;
            }
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
        id value = [self valueForKeyPath:propertyName] ? [self valueForKeyPath:propertyName] : nil;
        if (value) {
            [body setObject:value forKey:propertyName];
        }
    }
    
    // For self class properties
    properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:propName];
        if ([propertyName isEqualToString:@"calendar"]) {
            Calendar *calendar = [self valueForKey:@"calendar"];
            NSMutableArray *time_ranges = calendar.time_ranges;
            if (time_ranges) {
                [body setObject:time_ranges forKey:propertyName];
            }
            continue;
        }
        if ([propertyName isEqualToString:@"tutorCalendar"]) {
            continue;
        }
        id value = [self valueForKeyPath:propertyName] ? [self valueForKeyPath:propertyName] : nil;
        if (value) {
            [body setObject:value forKey:propertyName];
        }
    }
    
    free(properties);
    
    return body;
}

- (NSString *)description
{
    return [[self toDictionary] description];
}

@end
