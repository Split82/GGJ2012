//
//  Capsule.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Capsule.h"
#import "Tile.h"


@implementation Capsule {
    
}

@synthesize tile;
@synthesize components = _components;
@synthesize pos;

- (id)init {
    if (self=[super init])  {	

        [self schedule:@selector(nextFrame:)];
    }
    return self;    
} 

#pragma mark - Schedule

- (void)nextFrame:(ccTime)dt {
    
}

#pragma mark - Dealloc

- (void)destroy {
    
    [self unschedule:@selector(nextFrame:)];
}


@end
