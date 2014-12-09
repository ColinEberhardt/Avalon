//
//  NSObject+KVCWrapper.m
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "AVKeyValueObservingHelper.h"

@implementation AVKeyValueObservingHelper

+ (AVExceptionWrapper *)addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context forObject:(NSObject *)object {
  AVExceptionWrapper *result;
  @try {
    [object addObserver:anObserver forKeyPath:keyPath options:options context:context];
  }
  @catch (NSException *exception) {
    result = [AVExceptionWrapper new];
    result.exception = exception.name;
  }
  return result;
}

+ (AVValueWrapper *)tryGetValueForKeyPath:(NSString*) keyPath forObject:(NSObject *)object {
  AVValueWrapper *result = [AVValueWrapper new];
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

