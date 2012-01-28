//
//  TowerBuilding.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "TowerBuilding.h"
#import "MapModel.h"
#import "Capsule.h"

const int kMaxTowerBuffer = 7;

@implementation TowerBuilding {
    int buffer;
    BOOL lightOn;
    Capsule *lastConsumedCapsule;
    BOOL consuming;
    CCSequence *mainActionSequence;
}

@synthesize light;

const int cLight = 200;


+ (CGPoint)relativeGridPosOfEntrance {
    return ccp(-1,0);    
}

+ (CGPoint)relativeGridPosOfExit {
    return ccp(1,0);    
}

-(id)initWithGID:(unsigned int)initGID andGridPos:(CGPoint)initGridPos  {
    if (self=[super initWithGID:initGID andGridPos:initGridPos]) {	
        light = cLight;
    }
    return self;    
}


- (BOOL)isGridPosCapsuleEntrance:(CGPoint)gridPos {
    if (CGPointEqualToPoint([TowerBuilding relativeGridPosOfEntrance], ccpSub(gridPos, self.gridPos))) {
        return YES;
    }
    else {
        return NO;
    }    
}

- (BOOL)consumeCapsule:(Capsule*)newCapsule {
    if (!consuming) {
        consuming = YES;
        lastConsumedCapsule = newCapsule;
        [lastConsumedCapsule stopAllActions];

        [lastConsumedCapsule runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(consume)], nil]];    
        
        return YES;
    }
    else {
        return NO;
    }
}

- (void)action {
    
    if (buffer > 0 ) {
        buffer --;
        if (!lightOn) {
            [[MapModel sharedMapModel] updateLightForTiles:CGRectMake(self.gridPos.x - LUMINOSITY_TOWER_BUILDING_RADIUS, self.gridPos.y - LUMINOSITY_TOWER_BUILDING_RADIUS, 2*(LUMINOSITY_TOWER_BUILDING_RADIUS), 2*(LUMINOSITY_TOWER_BUILDING_RADIUS )) light:light radius:LUMINOSITY_TOWER_BUILDING_RADIUS];
        
            [[MapModel sharedMapModel] updateLightForGridRect:CGRectMake(self.gridPos.x - LUMINOSITY_TOWER_BUILDING_RADIUS - 1, self.gridPos.y - LUMINOSITY_TOWER_BUILDING_RADIUS - 1, 2*(LUMINOSITY_TOWER_BUILDING_RADIUS + 1), 2*(LUMINOSITY_TOWER_BUILDING_RADIUS + 1))];
            lightOn = YES;
        }
        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(action)], nil];
        [self runAction:mainActionSequence];    
        
    } else {
        if (lightOn) {
            lightOn = NO;
            [[MapModel sharedMapModel] updateLightForTiles:CGRectMake(self.gridPos.x - LUMINOSITY_TOWER_BUILDING_RADIUS, self.gridPos.y - LUMINOSITY_TOWER_BUILDING_RADIUS, 2*(LUMINOSITY_TOWER_BUILDING_RADIUS), 2*(LUMINOSITY_TOWER_BUILDING_RADIUS )) light:-light radius:LUMINOSITY_TOWER_BUILDING_RADIUS];
        
            [[MapModel sharedMapModel] updateLightForGridRect:CGRectMake(self.gridPos.x - LUMINOSITY_TOWER_BUILDING_RADIUS - 1, self.gridPos.y - LUMINOSITY_TOWER_BUILDING_RADIUS - 1, 2*(LUMINOSITY_TOWER_BUILDING_RADIUS + 1), 2*(LUMINOSITY_TOWER_BUILDING_RADIUS + 1))];
            mainActionSequence = nil;
        }
    }

}

- (void)consume{
    
    if (!mainActionSequence) {
        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(action)], nil];
        [self runAction:mainActionSequence];
    }
    
    if (buffer < kMaxTowerBuffer) {

        buffer ++;
        [lastConsumedCapsule stopAllActions];
        [lastConsumedCapsule removeFromParentAndCleanup:YES];
        consuming = NO;
    }else {
        
        CGPoint endGridPos = ccpAdd(self.gridPos, [TowerBuilding relativeGridPosOfExit]);
        Tile *nextTile = [[MapModel sharedMapModel]tileAtGridPos:endGridPos];   
        if (nextTile.isFree) {   
            nextTile.capsule =  lastConsumedCapsule;
            [lastConsumedCapsule spawnAtGridPos:endGridPos];
                        
            lastConsumedCapsule = nil;
            consuming = NO;
        } else {
            id capsuleActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:1],  [CCCallFunc actionWithTarget:self selector:@selector(consume)], nil];
            [lastConsumedCapsule stopAllActions];
            [lastConsumedCapsule runAction:capsuleActionSequence];             
        }
    }
}


@end
