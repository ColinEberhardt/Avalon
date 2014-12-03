//
//  AVSwizzle.m
//  Avalon
//
//  Created by Colin Eberhardt on 03/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "AVSwizzle.h"
#import <UIKit/UIKit.h>

@implementation UIButton (Beautify)

+ (void)load {
  [AVSwizzle swizzleClass:[UIButton class] method:@"didMoveToWindow"];
}

@end
