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
    CCTMXLayer *tiledLayer;
}

@synthesize map;
@synthesize mainLayer;

#pragma mark - Constants

const int LUMINOSITY_RADIUS = 5;

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
    // TODO slow square root
    return (int) round(light * MAX(0, (1 - sqrt(distance.x*distance.x + distance.y*distance.y) / LUMINOSITY_RADIUS)));
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
    tiledLayer = [map layerNamed:@"BG"];
    CCTMXLayer *buildinglayer = [map layerNamed:@"Buildings"];
    
    NSMutableArray* buildings = [[NSMutableArray alloc] init];
    
    for (int j = 0; j < map.mapSize.height; j++) {
        for (int i = 0; i < map.mapSize.width; i++) {
            
            tiledMapArray[i + (j* (int)map.mapSize.width)] = [[Tile alloc] initWithGID:[tiledLayer tileGIDAt:ccp(i,j)]];           
            tiledMapArray[i + (j* (int)map.mapSize.width)].pos = CGPointMake(i, j);

            unsigned int gidBuiding =  [buildinglayer tileGIDAt:ccp(i,j)];
            
            [tiledLayer setCornerIntensitiesForTile:ccc4(0, 0, 0, 0) x:i y:j];
            
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

            for (int i = -LUMINOSITY_RADIUS; i <= LUMINOSITY_RADIUS ; i ++) {
                for (int j = -LUMINOSITY_RADIUS; j <= LUMINOSITY_RADIUS; j ++) {
                    CGPoint offsetPoint = CGPointMake(point.x + i, point.y + j);
                    
                    if (! [self outOfMap:offsetPoint]) {
                        Tile* tile = [self tileAtPoint:offsetPoint];
                        tile.light = tile.light + [self calculateLightFromLight:towerBuilding.light atDistance:CGPointMake(i, j)];
                    }   
                }
            }
            // TODO update draw model
            
            CCTMXLayer* bgLayer = [map layerNamed:@"BG"];
            
            for (int i = -LUMINOSITY_RADIUS - 1; i <= LUMINOSITY_RADIUS + 1; ++i) {
                for (int j = -LUMINOSITY_RADIUS -1; j <= LUMINOSITY_RADIUS + 1; ++j) {
                    CGPoint offsetPoint = CGPointMake(point.x + i, point.y + j);
                    if (! [self outOfMap:offsetPoint]) {
                        int light = [self tileAtPoint:offsetPoint].light;
                        
                        // light in corners
                        NSUInteger tlLight = light;
                        NSUInteger trLight = light;
                        NSUInteger brLight = light;
                        NSUInteger blLight = light;
                        
                        // count of tiles which light is summed into corner
                        int tileCounts[] = {1, 1, 1, 1};
                        
                        // visit all neighbors
                        CGPoint neighborPoint = CGPointMake(offsetPoint.x - 1, offsetPoint.y - 1);
                        
                        // left top
                        if (neighborPoint.x >= 0 && neighborPoint.y >= 0) {
                            tlLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[0];
                        }
                        
                        // center top
                        neighborPoint.x += 1;
                        if (neighborPoint.y >= 0) {
                            tlLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[0];
                            
                            trLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[1];
                        }
                        
                        // right top
                        neighborPoint.x += 1;
                        if (neighborPoint.y >= 0 && neighborPoint.x < map.mapSize.width) {                            
                            trLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[1];
                        }
                        
                        // right center
                        neighborPoint.y += 1;
                        if (neighborPoint.x < map.mapSize.width) {                            
                            trLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[1];
                            
                            brLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[2];
                        }
                        
                        // right bottom
                        neighborPoint.y += 1;
                        if (neighborPoint.x < map.mapSize.width && neighborPoint.y < map.mapSize.height) {                            
                            brLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[2];
                        }
                        
                        // center bottom
                        neighborPoint.x -= 1;
                        if (neighborPoint.y < map.mapSize.height) {                            
                            brLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[2];
                            
                            blLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[3];
                        }
                        
                        // left bottom
                        neighborPoint.x -= 1;
                        if (neighborPoint.y < map.mapSize.height) {                            
                            blLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[3];
                        }
                        
                        // left center
                        neighborPoint.y -= 1;
                        if (neighborPoint.x >= 0) {                            
                            blLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[3];
                            
                            tlLight += [self tileAtPoint:neighborPoint].light;
                            ++tileCounts[0];
                        }
                        
                        // calculate the mean in each corner from neighbor tiles
                        tlLight = (int) round(tlLight / tileCounts[0]);
                        trLight = (int) round(trLight / tileCounts[1]);
                        brLight = (int) round(brLight / tileCounts[2]);
                        blLight = (int) round(blLight / tileCounts[3]);
                        
                        [bgLayer setCornerIntensitiesForTile:ccc4(tlLight, trLight, brLight, blLight) x:offsetPoint.x y:offsetPoint.y]; 
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

    return tiledMapArray[(int)(point.x + point.y*map.mapSize.width)];
}


- (CGPoint)posFromPixelPosition:(CGPoint)point; {
    return CGPointMake((int)(point.x / self.tileSize.width), (int)map.mapSize.height - (int)((point.y / self.tileSize.height)+0.5));
    
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
