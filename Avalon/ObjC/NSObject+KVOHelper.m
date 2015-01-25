//
//  NSObject+KVOHelper.m
//  Avalon
//
//  Created by Colin Eberhardt on 24/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

#import "NSObject+KVOHelper.h"

@implementation NSObject (KVOHelper)

- (NSString *)tryAddObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
  NSString *result;
  @try {
    [self addObserver:anObserver forKeyPath:keyPath options:options context:context];
  }
  @catch (NSException *exception) {
    result = exception.name;
  }
  return result;
}

- (AVValueWrapper *)tryGetValueForKeyPath:(NSString *)keyPath {
  AVValueWrapper *result = [AVValueWrapper new];
  @try {
    result.propertyValue = [self valueForKeyPath: keyPath];
  }
  @catch (NSException *exception) {
    result.exception = exception.name;
  }
  return result;
}

- (NSString *)trySetValue:(id)value forKeyPath:(NSString *)keyPath {
  @try {
    [self setValue:value forKey:keyPath];
  }
  @catch (NSException *exception) {
    return exception.name;
  }
  return nil;
}

@end
