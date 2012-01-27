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

- (id)initWithGID:(int)initGID {
        if( (self=[super init]) ) {	
            gid = initGID;
        }
        return self;
    }

@end
