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
#import "MixerBuilding.h"
#import "MineBuilding.h"

@implementation MapModel {
    
    __strong Tile **tiledMapArray;
    
    CCTMXTiledMap *map;
    
    CCTMXLayer *buildinglayer;
    CCTMXLayer* bgLayer;
    
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

- (CGRect)gridRectForBuilding:(Building*)building atGridPos:(CGPoint)gridPos {
    switch (building.gid) {
        case BuildingTypeMixer:
            return CGRectMake(gridPos.x - 2, gridPos.y - 2, gridPos.x + 1, gridPos.y + 1);
            break;
            
        default:
            return CGRectMake(gridPos.x, gridPos.y, 0, 0);
            break;
    }
}

- (BOOL)isFreeGridRectForConstruction:(CGRect)gridRect {
    
    CGPoint tileGridPos;
    for (int i = (int)gridRect.origin.x; i <= (int)(gridRect.origin.x + gridRect.size.width); ++i) {
        for (int j = (int)gridRect.origin.y; j <= (int)(gridRect.origin.y + gridRect.size.height); ++j) {
            tileGridPos = CGPointMake(i, j);
            if ([self tileAtGridPos:tileGridPos].isStandingItem) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)setGridRect:(CGRect)gridRect withStandingItem:(BOOL)standingItem {
    
    CGPoint tileGridPos;
    for (int i = (int)gridRect.origin.x; i <= (int)(gridRect.origin.x + gridRect.size.width); ++i) {
        for (int j = (int)gridRect.origin.y; j <= (int)(gridRect.origin.y + gridRect.size.height); ++j) {
            tileGridPos = CGPointMake(i, j);
            [self tileAtGridPos:tileGridPos].isStandingItem = standingItem;
        }
    }
   
}

#pragma mark - Getters

- (CGPoint)tileCenterPositionForGripPos:(CGPoint)gridPos {
    return CGPointMake( (gridPos.x + 0.5) * self.tileSize.width, (map.mapSize.height - gridPos.y - 0.5) * self.tileSize.height);
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
    bgLayer = [map layerNamed:@"BG"];
    buildinglayer = [map layerNamed:@"Buildings"];
    
    NSMutableArray* buildings = [[NSMutableArray alloc] init];
    
    for (int j = 0; j < map.mapSize.height; j++) {
        for (int i = 0; i < map.mapSize.width; i++) {
            
            tiledMapArray[i + (j* (int)map.mapSize.width)] = [[Tile alloc] initWithGID:[bgLayer tileGIDAt:ccp(i,j)]];           
            tiledMapArray[i + (j* (int)map.mapSize.width)].pos = CGPointMake(i, j);

            unsigned int gidBuiding =  [buildinglayer tileGIDAt:ccp(i,j)];
            
            [bgLayer setCornerIntensitiesForTile:ccc4(0, 0, 0, 0) x:i y:j];
            
            if (gidBuiding) {
                Building* building = [Building createBuildingFromGID:gidBuiding andGridPos:CGPointMake(i, j)];
                if (building) {
                    [buildings addObject:building];
                }
            }
        }
        
    }
    
    for (Building* building in buildings) {
        [self addBuilding:building AtPoint:building.gridPos];
        [mainLayer addChild:building];
    }
}

#pragma mark - Update
- (void)updateLightForGridRect:(CGRect)updateGridRect {
    // TODO update draw model
    
    bgLayer = [map layerNamed:@"BG"];
    
    for (int i = (int)updateGridRect.origin.x; i <= (int)(updateGridRect.origin.x + updateGridRect.size.width); ++i) {
        for (int j = (int)updateGridRect.origin.y; j <= (int)(updateGridRect.origin.y + updateGridRect.size.height); ++j) {
            CGPoint offsetPoint = CGPointMake(i, j);
            if (! [self outOfMap:offsetPoint]) {
                int light = [self tileAtGridPos:offsetPoint].light;
                
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
                    tlLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[0];
                }
                
                // center top
                neighborPoint.x += 1;
                if (neighborPoint.y >= 0) {
                    tlLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[0];
                    
                    trLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[1];
                }
                
                // right top
                neighborPoint.x += 1;
                if (neighborPoint.y >= 0 && neighborPoint.x < map.mapSize.width) {                            
                    trLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[1];
                }
                
                // right center
                neighborPoint.y += 1;
                if (neighborPoint.x < map.mapSize.width) {                            
                    trLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[1];
                    
                    brLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[2];
                }
                
                // right bottom
                neighborPoint.y += 1;
                if (neighborPoint.x < map.mapSize.width && neighborPoint.y < map.mapSize.height) {                            
                    brLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[2];
                }
                
                // center bottom
                neighborPoint.x -= 1;
                if (neighborPoint.y < map.mapSize.height) {                            
                    brLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[2];
                    
                    blLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[3];
                }
                
                // left bottom
                neighborPoint.x -= 1;
                if (neighborPoint.y < map.mapSize.height) {                            
                    blLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[3];
                }
                
                // left center
                neighborPoint.y -= 1;
                if (neighborPoint.x >= 0) {                            
                    blLight += [self tileAtGridPos:neighborPoint].light;
                    ++tileCounts[3];
                    
                    tlLight += [self tileAtGridPos:neighborPoint].light;
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

- (BOOL)addMover:(MoverType)moverType atGridPos:(CGPoint)gridPos {
    
    
    if ([self tileAtGridPos:gridPos].isStandingItem) {
        return NO;
    }
    else {
        if ([[self tileAtGridPos:gridPos] addMover:moverType]) {
            [bgLayer setTileGID:moverType at:gridPos];
            return YES;
        } 
        else {
            return NO;
        }
    }
}

- (BOOL)addBuilding:(Building*)building AtPoint:(CGPoint)point {
    if ([self outOfMap:point]) {
        return NO;
    }
    
    CGRect gridRectForBuilding = [self gridRectForBuilding:building atGridPos:point];
    
    if ([self tileAtGridPos:point].building  || ![self isFreeGridRectForConstruction:gridRectForBuilding]) {
        return NO;
    } else {
        [self tileAtGridPos:point].building = building;
        // TODO do somethnig with other tiles
        
        if ([building isKindOfClass:[MixerBuilding class]]) {
            
        }
        else if ([building isKindOfClass:[TowerBuilding class]]) {
            // TODO
            TowerBuilding  *towerBuilding = (TowerBuilding*)building;

            for (int i = -LUMINOSITY_RADIUS; i <= LUMINOSITY_RADIUS ; i ++) {
                for (int j = -LUMINOSITY_RADIUS; j <= LUMINOSITY_RADIUS; j ++) {
                    CGPoint offsetPoint = CGPointMake(point.x + i, point.y + j);
                    
                    if (! [self outOfMap:offsetPoint]) {
                        Tile* tile = [self tileAtGridPos:offsetPoint];
                        tile.light = tile.light + [self calculateLightFromLight:towerBuilding.light atDistance:CGPointMake(i, j)];
                    }   
                }
            }
            
            [self updateLightForGridRect:CGRectMake(point.x - LUMINOSITY_RADIUS - 1, point.y - LUMINOSITY_RADIUS - 1, 2*(LUMINOSITY_RADIUS + 1), 2*(LUMINOSITY_RADIUS + 1))];

        }
        
        [self setGridRect:gridRectForBuilding withStandingItem:YES];
        return YES;
    }
}

- (BOOL)destroyBuildingAtPoint:(CGPoint)point {
    if ([self outOfMap:point]) {
        return NO;
    } 
    
    if (![self tileAtGridPos:point].building) {
        return NO;
    } else {
        Building *building = [self tileAtGridPos:point].building;
        CGRect gridRectForBuilding = [self gridRectForBuilding:building atGridPos:point];
        
        [self tileAtGridPos:point].building = building;
        
        if ([building isKindOfClass:[TowerBuilding class]]) {
            // TODO
            TowerBuilding  *towerBuilding = (TowerBuilding*)building;
            
            for (int i = -5; i <= 5 ; i ++) {
                for (int j = -5; i <= 5; j ++) {
                    if ([self outOfMap:CGPointMake(point.x + i, point.y + j)]) {
                        [self tileAtGridPos:point].light -= [self calculateLightFromLight:towerBuilding.light atDistance:CGPointMake(i, j)]; 
                    }   
                }
            }
            // TODO update draw model
        }
        
        [self tileAtGridPos:point].building = nil;

        [self setGridRect:gridRectForBuilding withStandingItem:NO];
        
        return YES;
    }

}

#pragma mark - Getters

- (Tile*)tileAtGridPos:(CGPoint)point {
    
    if ([self outOfMap:point]) 
        return nil;

    return tiledMapArray[(int)(point.x + point.y*map.mapSize.width)];
}


- (CGPoint)gridPosFromPixelPosition:(CGPoint)point; {
    return CGPointMake(floorf(point.x / self.tileSize.width), floorf(map.mapSize.height - (point.y / self.tileSize.height)) );
    
}

- (Building*)buildingAtPoint:(CGPoint)point {

    if ([self outOfMap:point]) 
        return nil;
    
    return [self tileAtGridPos:point].building;
}

#pragma mark - dealloc

- (void)dealloc {
    
    [self freeMap]; 
}

@end
