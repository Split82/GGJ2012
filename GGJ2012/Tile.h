//
//  Tile.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capsule.h"
@class Building;
@class MapModel;

typedef enum{
    TileTypeEmpty = 36,
    TileTypeMoverRight = 7,
    TileTypeMoverLeft = 6,
    TileTypeMoverUp = 8,
    TileTypeMoverDown = 9,
    TileTypeMoverContinue = 5,
    TileTypeSwitcherRight = 2,
    TileTypeSwitcherLeft = 1,
    TileTypeSwitcherUp = 4,
    TileTypeSwitcherDown = 3,
    
    TileTypeBuildingMine = 81,
    TileTypeBuildingTowerDark = 82,
    TileTypeBuildingTower = 83,
    TileTypeBuildingMixer = 84
    
    
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
@property (nonatomic, assign) CGPoint gridPos;
@property (nonatomic, assign) int light;
@property (nonatomic, assign) ccColor4B cornerIntensities;


- (id)initWithGID:(int)gid;
- (void)setupFromGID:(int)newGID;
- (BOOL)updateDoChange;

- (BOOL)isFree;
- (CGPoint)nextGridMoveVectorForLastMoveGridVector:(CGPoint)lastMoveGridVector;

- (BOOL)addMover:(int)moverType;
- (BOOL)removeStandingItem;


- (BOOL)isMover; 
- (BOOL)isSwitcher;
- (void)switchMover;
- (BOOL)neighborEnterToMe:(CGPoint)relativePos;
- (CGPoint)nextRelativeNeighborDirectionFrom:(CGPoint)lastDirection;

@end
