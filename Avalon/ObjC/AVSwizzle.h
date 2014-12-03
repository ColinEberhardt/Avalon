//
//  AVSwizzle.h
//  Avalon
//
//  Created by Colin Eberhardt on 03/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVSwizzle : NSObject

+(void)swizzleClass:(Class)class method:(NSString*)methodName;

@end
