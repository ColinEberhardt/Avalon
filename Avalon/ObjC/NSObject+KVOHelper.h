//
//  NSObject+KVOHelper.h
//  Avalon
//
//  Created by Colin Eberhardt on 24/01/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVValueWrapper.h"

@interface NSObject (KVOHelper)

- (NSString *)tryAddObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

- (AVValueWrapper *)tryGetValueForKeyPath:(NSString *)keyPath;

- (NSString *)trySetValue:(id)value forKeyPath:(NSString *)keyPath;

@end
