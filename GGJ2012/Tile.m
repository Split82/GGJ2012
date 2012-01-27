//
//  Tile.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Tile.h"

@implementation Tile

@synthesize gid;
@synthesize capsule;

- (id)initWithGID:(int)initGID {
        if( (self=[super init]) ) {	
            gid = initGID;
        }
        return self;
    }

- (BOOL)isFree {
    // TODO
    return NO;
}

- (CGPoint)nextMove:(CGPoint)r {
    // TODO
    return r;
}

@end
