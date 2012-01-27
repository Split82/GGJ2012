//
//  Tile.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Tile.h"

@implementation Tile {
    BOOL freeTile;
}

@synthesize gid;
@synthesize capsule;
@synthesize building;

- (id)initWithGID:(int)initGID {
        if( (self=[super init]) ) {	
            gid = initGID;
            
            // TODO
            switch (gid) {
                case TileTypeBuildingTower:
                case TileTypeBuildingCombination:
                case TileTypeMine:
                    freeTile = NO;
                    break;
                    
                default:
                    freeTile = YES;
                    break;
            }
        }
        return self;
    }

- (BOOL)isFree {
    
    if (capsule || building) {
        return NO ;  
    } else {

        return freeTile;
    }
}

- (CGPoint)nextMove:(CGPoint)r {

    switch (gid) {
                    
        case TileTypeMoverUp:
            return CGPointMake(0, -1);
            break;
            
        case TileTypeMoverDown:
            return CGPointMake(0, 1);
            break;
            
        case TileTypeMoverLeft:
            return CGPointMake(-1, 0);
            break;
            
        case TileTypeMoverRight:
            return CGPointMake(1, 0);
            break;
            
        case TileTypeMoverContinue:
            return r;
            
        case TileTypeEmpty:
        default:
            return CGPointMake(0, 0);
            break;
            
    }
    // TODO
    return r;
}

@end
