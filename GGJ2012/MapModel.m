//
//  MapModel.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MapModel.h"
#import "Tile.h"

@implementation MapModel {
    
    __strong Tile **tiledMapArray;
    
    CCTMXTiledMap *map;
}

@synthesize map;

#pragma mark - Singleton

static MapModel *sharedMapModel = nil;

+ (MapModel*)sharedMapModel {
    if (!sharedMapModel) {
        sharedMapModel = [[MapModel alloc] init];
    }
    return sharedMapModel;
}



#pragma mark - Helpers

- (void)freeMap {
    if (map) {
        
        for (int i = 0; i < map.mapSize.width; i++) {
            for (int j = 0; j < map.mapSize.height; j++) {
                tiledMapArray[i + (j* (int)map.mapSize.width)] = nil;
            }
        }
        free(tiledMapArray);        
    }
    map = nil;
}

- (BOOL)outOfMap:(CGPoint)point {
    
    return (point.x < 0 || point.y < 0 || point.x >= map.mapSize.width || point.y >= map.mapSize.height) ;
}

#pragma mark - Setters

- (void)setMap:(CCTMXTiledMap*)newMap {
    
    [self freeMap];

    map = newMap;

    tiledMapArray =  (__strong Tile **)calloc(sizeof(Tile *), map.mapSize.width * map.mapSize.height);
    CCTMXLayer *layer = [map layerNamed:@"Layer 0"];
    
    for (int i = 0; i < map.mapSize.width; i++) {
        for (int j = 0; j < map.mapSize.height; j++) {
            tiledMapArray[i + (j* (int)map.mapSize.width)] = [[Tile alloc] initWithGID:[layer tileGIDAt:ccp(i,j)]];           
        }
        
    }
}

#pragma mark - Update

- (BOOL)createBuilding:(Building*)building AtPoint:(CGPoint)point {
    if ([self outOfMap:point]) {
        return NO;
    }
    
    if ([self tileAtPoint:point].building) {
        return NO;
    } else {
        [self tileAtPoint:point].building = building;
        // TODO do somethnig with other tiles
        return YES;
    }
}

- (BOOL)destroyBuildingAtPoint:(CGPoint)point {
    if ([self outOfMap:point]) {
        return NO;
    } 
    
    if (![self tileAtPoint:point].building) {
        return NO;
    } else {
        [self tileAtPoint:point].building = nil;
        // TODO do somethnig with other tiles
        return YES;
    }

}

#pragma mark - Getters

- (Tile*)tileAtPoint:(CGPoint)point {
    
    if ([self outOfMap:point]) 
        return nil;

    return tiledMapArray[(int)(point.x + point.y*map.mapSize.height)];
}


- (Building*)buildingAtPoint:(CGPoint)point {

    if ([self outOfMap:point]) 
        return nil;
    
    return [self tileAtPoint:point].building;
}

#pragma mark - dealloc

- (void)dealloc {
    
    [self freeMap]; 
}

@end
