//
//  Tile.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Tile.h"
#import "MapModel.h"

@implementation Tile {
    BOOL freeTile;
    BOOL mover;  

}

@synthesize gid;
@synthesize belowGID;
@synthesize capsule;
@synthesize gridPos;
@synthesize building;
@synthesize light;
@synthesize cornerIntensities;
@synthesize isStandingItem;

#pragma mark - Helper

- (void)setupFromGID:(int)newGID {
    
    gid = newGID;
    mover = NO;
    isStandingItem = NO;
    // TODO
    switch (gid) {
        case TileTypeMoverUp:
        case TileTypeMoverDown:
        case TileTypeMoverLeft:
        case TileTypeMoverRight:
        case TileTypeMoverContinue:
            mover = YES;
            freeTile = YES;

            break;
            
        case TileTypeBuildingTower:
        case TileTypeBuildingMixer:
        case TileTypeMine:
            freeTile = NO;
            isStandingItem = YES;
            break;
            
        default:
            freeTile = YES;
            break;
    }    
}

- (id)initWithGID:(int)initGID {
    
        if (self=[super init])  {	
            [self setupFromGID:initGID];
        }
        return self;
    }

- (BOOL)isFree {
    if (capsule || (building && ![building isFreeAtGridPos:self.gridPos])) {
        return NO ;  
    } else {
        return freeTile;
    }
}

- (BOOL)neighborEnterToMe:(CGPoint)relativePos {
    
    Tile * neighbor= [[MapModel sharedMapModel] tileAtGridPos:ccpAdd(self.gridPos, relativePos)];
    if (neighbor) {
        if (relativePos.x == -1 && relativePos.y == 0 && neighbor.gid == TileTypeMoverRight) {
            return YES;
        }
        else if (relativePos.x == 1 && relativePos.y == 0 && neighbor.gid == TileTypeMoverLeft) {
                return YES;
        }
        else if (relativePos.x == 0 && relativePos.y == -1 && neighbor.gid == TileTypeMoverDown) {
            return YES;
        }        
        else if (relativePos.x == 0 && relativePos.y == 1 && neighbor.gid == TileTypeMoverUp) {
            return YES;
        } 
    }
    return NO;
}

- (void)update {
    
}

- (BOOL)isSwitcher {
    return NO;
}

- (BOOL)addMover:(int)moverType {
    if (isStandingItem) {
        return NO;
    }
    else {
        
        if (self.isMover) {
            
        }
        
        belowGID = self.gid;
        [self setupFromGID:moverType];

        return YES;
    }
}

- (BOOL)removeStandingItem {
    if (! isStandingItem) {
        return NO;
    }
    else {
        [self setGid:belowGID];
        isStandingItem = NO;
        return YES;

    }
}

- (BOOL)isMover {
    return mover;
}

- (CGPoint)nextGridMoveVectorForLastMoveGridVector:(CGPoint)lastMoveGridVector {

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
            return lastMoveGridVector;
            
        case TileTypeEmpty:
        default:
            return CGPointMake(0, 0);
            break;
            
    }

}

@end
