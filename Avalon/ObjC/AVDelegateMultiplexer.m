//
//  AVDelegateMultiplexer.m
//  Avalon
//
//  Created by Colin Eberhardt on 07/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "AVDelegateMultiplexer.h"

@implementation AVDelegateMultiplexer

- (BOOL)respondsToSelector:(SEL)aSelector {
  if ([super respondsToSelector:aSelector])
    return YES;
  
  if ([_delegate respondsToSelector:aSelector] ||
      [_proxiedDelegate respondsToSelector:aSelector]) {
    return YES;
  }
  return NO;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  // can this class create the signature?
  NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
  if ([_delegate respondsToSelector:aSelector])
  {
    return [_delegate methodSignatureForSelector:aSelector];
  }
  if ([_proxiedDelegate respondsToSelector:aSelector])
  {
    return [_proxiedDelegate methodSignatureForSelector:aSelector];
  }
  return signature;
}

-(void)forwardInvocation:(NSInvocation*)anInvocation {
  // forward the invocation to every delegate
  if ([_delegate respondsToSelector:[anInvocation selector]])
  {
    [anInvocation invokeWithTarget:_delegate];
  }
  if ([_proxiedDelegate respondsToSelector:[anInvocation selector]])
  {
    [anInvocation invokeWithTarget:_proxiedDelegate];
  }
}

@end
