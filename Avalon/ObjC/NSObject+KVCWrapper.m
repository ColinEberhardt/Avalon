//
//  NSObject+KVCWrapper.m
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "NSObject+KVCWrapper.h"

@implementation NSObjectHelper

+ (NSValueWrapper *)tryGetValueForKeyPath:(NSString*) keyPath forObject:(NSObject *)object {
  NSValueWrapper *result = [NSValueWrapper new];
  @try {
    result.propertyValue = [object valueForKeyPath: keyPath];
  }
  @catch (NSException *exception) {
    result.exception = exception.name;
  }
  return result;
}

+ (NSString *)trySetValue:(id)value forKeyPath:(NSString *)keyPath forObject:(NSObject *)object {
  @try {
    [object setValue:value forKey:keyPath];
  }
  @catch (NSException *exception) {
    return exception.name;
  }
  return nil;
}

@end

