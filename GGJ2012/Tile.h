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
@class MapModel;

enum MoverType;

typedef enum{
    TileTypeEmpty = 0,
    TileTypeMoverRight = 15,
    TileTypeMoverLeft = 12,
    TileTypeMoverUp = 14,
    TileTypeMoverDown = 13,
    TileTypeMoverContinue = 11,
    TileTypeBuildingMixer = 26,
    TileTypeBuildingTower = 27,
    TileTypeMine = 28
} TileType;

typedef enum {
    // same as tiles
    MoverTypeEmpty = 0,
    MoverTypeRight = TileTypeMoverRight,
    MoverTypeLeft = TileTypeMoverLeft,
    MoverTypeUp = TileTypeMoverUp,
    MoverTypeDown = TileTypeMoverDown,    
} MoverType;

@interface Tile : NSObject

@property (nonatomic, assign) unsigned int gid;
@property (nonatomic, assign) unsigned int belowGID;
@property (nonatomic, strong) Capsule *capsule;
@property (nonatomic, strong) Building *building;
@property (nonatomic, assign) BOOL isStandingItem;
@property (nonatomic, assign) CGPoint pos;
@property (nonatomic, assign) int light;


- (id)initWithGID:(int)gid;
- (void)setupFromGID:(int)newGID;

- (BOOL)isFree;
- (CGPoint)nextGridMoveVectorForLastMoveGridVector:(CGPoint)lastMoveGridVector;

- (BOOL)addMover:(int)moverType;
- (BOOL)removeStandingItem;


- (BOOL)isMover;

@end
