//
//  MapModel.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MapModel.h"
#import "Tile.h"
#import "TowerBuilding.h"
#import "MineBuilding.h"

@implementation MapModel {
    
    __strong Tile **tiledMapArray;
    
    CCTMXTiledMap *map;
}

@synthesize map;
@synthesize mainLayer;

#pragma mark - Constants

const NSUInteger LUMINOSITY_RADIUS = 5;

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

- (int)calculateLightFromLight:(int)light atDistance:(CGPoint)distance {
    return  MAX(0, light - (distance.x*distance.x + distance.y*distance.y));
}

- (BOOL)outOfMap:(CGPoint)point {
    
    return (point.x < 0 || point.y < 0 || point.x >= map.mapSize.width || point.y >= map.mapSize.height) ;
}

- (CGSize)tileSize {
    if (map) {
        return map.tileSize;
    } else {
        return CGSizeMake(0, 0);
    }
    
}


#pragma mark - Setters

- (void)setMap:(CCTMXTiledMap*)newMap {
    
    [self freeMap];

    map = newMap;
    
    tiledMapArray =  (__strong Tile **)calloc(sizeof(Tile *), map.mapSize.width * map.mapSize.height);
    CCTMXLayer *tiledLayer = [map layerNamed:@"BG"];
    CCTMXLayer *buildinglayer = [map layerNamed:@"Buildings"];
    
    NSMutableArray* buildings = [[NSMutableArray alloc] init];
    
    for (int j = 0; j < map.mapSize.height; j++) {
        for (int i = 0; i < map.mapSize.width; i++) {
            
            tiledMapArray[i + (j* (int)map.mapSize.width)] = [[Tile alloc] initWithGID:[tiledLayer tileGIDAt:ccp(i,j)]];           
            tiledMapArray[i + (j* (int)map.mapSize.width)].pos = CGPointMake(i, j);

            unsigned int gidBuiding =  [buildinglayer tileGIDAt:ccp(i,j)];
            
            if (gidBuiding) {
                Building* building = [Building createBuildingFromGID:gidBuiding andPos:CGPointMake(i, j)];
                if (building) {
                    [buildings addObject:building];                    
                }
            }
        }
        
    }
    
    for (Building* building in buildings) {
        [self addBuilding:building AtPoint:building.pos];
        [mainLayer addChild:building];
    }
}

#pragma mark - Update

- (BOOL)addBuilding:(Building*)building AtPoint:(CGPoint)point {
    if ([self outOfMap:point]) {
        return NO;
    }
    
    if ([self tileAtPoint:point].building) {
        return NO;
    } else {
        [self tileAtPoint:point].building = building;
        // TODO do somethnig with other tiles
        
        if ([building isKindOfClass:[TowerBuilding class]]) {
            // TODO
            TowerBuilding  *towerBuilding = (TowerBuilding*)building;

            for (int i = -5; i <= 5 ; i ++) {
                for (int j = -5; j <= 5; j ++) {
                    CGPoint offsetPoint = CGPointMake(point.x + i, point.y + j);
                    
                    if (! [self outOfMap:offsetPoint]) {
                        Tile* tile = [self tileAtPoint:offsetPoint];
                        tile.light = tile.light + [self calculateLightFromLight:towerBuilding.light atDistance:CGPointMake(i, j)];
                    }   
                }
            }
            // TODO update draw model
            
            CCTMXLayer* bgLayer = [map layerNamed:@"BG"];
            
            for (int i = -5 - 1; i <= 5 + 1; ++i) {
                for (int j = -5 -1; j <= 5 +1; ++j) {
                    if (! [self outOfMap:CGPointMake(point.x + i, point.y + j)]) {
                        int light = [self tileAtPoint:CGPointMake(point.x + i, point.y + j)].light;
                        
                        [bgLayer setCornerIntensitiesForTile:ccc4(light, light, light, light) x:point.x + i y:point.y + j]; 
                    } 
                }
            }

        }
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
        Building *building = [self tileAtPoint:point].building;
        
        if ([building isKindOfClass:[TowerBuilding class]]) {
            // TODO
            TowerBuilding  *towerBuilding = (TowerBuilding*)building;
            
            for (int i = -5; i <= 5 ; i ++) {
                for (int j = -5; i <= 5; j ++) {
                    if ([self outOfMap:CGPointMake(point.x + i, point.y + j)]) {
                        [self tileAtPoint:point].light -= [self calculateLightFromLight:towerBuilding.light atDistance:CGPointMake(i, j)]; 
                    }   
                }
            }
            // TODO update draw model
        }
        
        [self tileAtPoint:point].building = nil;

        return YES;
    }

}

#pragma mark - Getters

- (Tile*)tileAtPoint:(CGPoint)point {
    
    if ([self outOfMap:point]) 
        return nil;

    return tiledMapArray[(int)(((int)point.x) + ((int)point.y) * map.mapSize.width)];
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
