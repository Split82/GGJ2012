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
#import "Tile.h"

@implementation Building

@synthesize tile;
@synthesize gid;

+ (Building*)createBuildingFromGID:(unsigned int)gid {
    switch (gid) {
        case BuildingTypeMineWater:
        case BuildingTypeMineEarth:
        case BuildingTypeMineFire:
        case BuildingTypeMineWind:
            return [[TowerBuilding alloc] initWithGID:gid];
            break;
            
        case BuildingTypeTower:
            return [[MineBuilding alloc] initWithGID:gid];
            break;
            
        case BuildingTypeNone:
        default:
            return nil;
            break;
    }
}

- (id)initWithGID:(unsigned int)initGID {
    if (self=[super init])  {	
        gid = initGID;
    
    }
    return self;    
}

@end
