//
//  Building.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

@class Tile;

typedef enum {
    BuildingTypeNone = 0,
    BuildingTypeTower = 2,
    BuildingCombinatMixer = 1,
    BuildingTypeMineWater = 3,
    BuildingTypeMineEarth = 4,
    BuildingTypeMineWind = 5,
    BuildingTypeMineFire = 6
    
}BuildingType;

@interface Building : CCNode

@property (nonatomic, assign) CGPoint gridPos;
@property (nonatomic, assign) unsigned int gid;

+ (Building*)createBuildingFromGID:(unsigned int)gid andGridPos:(CGPoint)pos;

-(id)initWithGID:(unsigned int)gid andGridPos:(CGPoint)initPos;

@end
