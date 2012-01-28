//
//  Tile.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capsule.h"
#import "Building.h"

typedef enum{
    TileTypeEmpty = 0,
    TileTypeMoverRight = 1,
    TileTypeMoverLeft = 2,
    TileTypeMoverUp = 3,
    TileTypeMoverDown = 4,
    TileTypeMoverContinue = 5,
    TileTypeBuildingMixer = 6,
    TileTypeBuildingTower = 7,
    TileTypeMine = 8
} TileType;

@interface Tile : NSObject

@property (nonatomic, assign) unsigned int gid;
@property (nonatomic, strong) Capsule *capsule;
@property (nonatomic, strong) Building *building;
@property (nonatomic, assign) CGPoint pos;
@property (nonatomic, assign) int light;


- (id)initWithGID:(int)gid;

- (BOOL)isFree;
- (CGPoint)nextMove:(CGPoint)r;

@end
