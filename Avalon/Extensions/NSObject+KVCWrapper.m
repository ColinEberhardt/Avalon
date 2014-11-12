//
//  NSObject+KVCWrapper.m
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "NSObject+KVCWrapper.h"

@implementation NSObjectHelper

+ (id)tryGetValueForKeyPath:(NSString*) keyPath forObject:(NSObject *)object {
  return [object valueForKeyPath: keyPath];
}

@end

