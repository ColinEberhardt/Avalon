//
//  NSObject+KVCWrapper.h
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObjectHelper: NSObject

+ (id)tryGetValueForKeyPath:(NSString*) keyPath forObject:(NSObject *)object;

@end

