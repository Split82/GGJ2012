//
//  MapModel.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
#import "Building.h"

@interface MapModel : NSObject

@property (nonatomic, readwrite, strong) CCTMXTiledMap *map;
@property (nonatomic, weak) CCLayer *mainLayer; 
@property (nonatomic, readonly) CGSize tileSize;

+ (MapModel*)sharedMapModel;

- (Tile*)tileAtPoint:(CGPoint)point;
- (Building*)buildingAtPoint:(CGPoint)point;

// Update map
- (BOOL)addBuilding:(Building*)building AtPoint:(CGPoint)point;
- (BOOL)destroyBuildingAtPoint:(CGPoint)point;

@end
