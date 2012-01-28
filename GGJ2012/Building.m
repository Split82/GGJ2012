//
//  Building.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Building.h"
#import "MineBuilding.h"
#import "TowerBuilding.h"
#import "MixerBuilding.h"
#import "Tile.h"

@implementation Building

@synthesize gid;
@synthesize gridPos;

+ (Building*)createBuildingFromGID:(unsigned int)gid andGridPos:(CGPoint)pos {
    switch (gid) {

        case BuildingTypeTower:
            return [[TowerBuilding alloc] initWithGID:gid andGridPos:pos];
            break;
            
        case BuildingTypeMixer:
            return [[MixerBuilding alloc] initWithGID:gid andGridPos:pos];
            
        case BuildingTypeMineWater:
        case BuildingTypeMineEarth:
        case BuildingTypeMineFire:
        case BuildingTypeMineWind:
            return [[MineBuilding alloc] initWithGID:gid andGridPos:pos];
            break;
            
        case BuildingTypeNone:
        default:
            return nil;
            break;
    }
}

-(id)initWithGID:(unsigned int)initGID andGridPos:(CGPoint)initGridPos {
    if (self=[super init])  {	
        gid = initGID;
        gridPos = initGridPos;
    
    }
    return self;    
}

@end
