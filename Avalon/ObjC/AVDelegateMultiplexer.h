//
//  AVDelegateMultiplexer.h
//  Avalon
//
//  Created by Colin Eberhardt on 07/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVDelegateMultiplexer : NSObject

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id proxiedDelegate;

@end
