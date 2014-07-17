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
    
    // TODO : If root node is expected by API
//    NSString *rootName = [NSStringFromClass([self class]) lowercaseString];
//
//    return @{rootName: body};
    
    return body;
}


@end
