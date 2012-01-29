//
//  MapModel.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"
#import "HelloWorldLayer.h"
#import "Tile.h"
#import "Creeper.h"

#define LUMINOSITY_TOWER_BUILDING_RADIUS 7
#define LUMINOSITY_MINE_BUILDING_RADIUS 2
#define LUMINOSITY_MIXER_BUILDING_RADIUS 5
#define LUMINOSITY_MOVER_RADIUS 3
#define LUMINOSITY_MOVER_LIGHT 5

@interface MapModel : NSObject

@property (nonatomic, readwrite, strong) CCTMXTiledMap *map;
@property (nonatomic, weak) HelloWorldLayer *mainLayer; 
@property (nonatomic, readonly) CGSize tileSize;

@property (nonatomic, readonly) CCTMXLayer *buildingslayer;
@property (nonatomic, readonly) CCTMXLayer* bgLayer;

+ (MapModel*)sharedMapModel;

- (Tile*)tileAtGridPos:(CGPoint)point;
- (CGPoint)gridPosFromPixelPosition:(CGPoint)point;
- (Building*)buildingAtGridPos:(CGPoint)gridPos;

- (Creeper*)spawnCreeperAtGridPos:(CGPoint)gridPos;

- (CGPoint)tileCenterPositionForGripPos:(CGPoint)gridPos;

// Update map
- (BOOL)addBuilding:(Building*)building AtPoint:(CGPoint)point create:(BOOL)create ;
- (BOOL)destroyBuildingAtPoint:(CGPoint)point;

- (void)updateLightForTiles:(CGRect)updateGridRect light:(int)light radius:(int)radius;
- (void)updateLightForGridRect:(CGRect)updateGridRect;

- (void)updateTileAtGridPos:(CGPoint)gridPos;


- (BOOL)addMover:(MoverType)moverType atGridPos:(CGPoint)gridPos;

- (BOOL)deleteMoverAtGridPos:(CGPoint)gridPos;


- (BOOL)isOutOfScreen:(CGPoint) position size:(CGSize)size;

- (CCSprite*)createTowerBuildingSprite;
- (CCSprite*)createMixerBuildingSprite;

@end
