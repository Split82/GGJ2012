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
    BuildingTypeTower = 1,
    BuildingTypeMineWater = 2,
    BuildingTypeMineEarth = 3,
    BuildingTypeMineWind = 4,
    BuildingTypeMineFire = 5
    
}BuildingType;

@interface Building : CCSprite

@property (nonatomic, weak) Tile* tile;
@property (nonatomic, assign) unsigned int gid;

+(Building*)createBuildingFromGID:(unsigned int)gid;

-(id)initWithGID:(unsigned int)gid;

@end
