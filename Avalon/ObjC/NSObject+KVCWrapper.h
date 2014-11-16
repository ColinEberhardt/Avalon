//
//  NSObject+KVCWrapper.h
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSValueWrapper.h"

@interface NSObjectHelper: NSObject

+ (NSValueWrapper *)tryGetValueForKeyPath:(NSString *)keyPath forObject:(NSObject *)object;

+ (NSString *)trySetValue:(id)value forKeyPath:(NSString *)keyPath forObject:(NSObject *)object;

@end

