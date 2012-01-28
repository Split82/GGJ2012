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

const int kMaxTowerBuffer = 10;

@implementation TowerBuilding {
    int buffer;
    Capsule *lastConsumedCapsule;
    BOOL consuming;
}

@synthesize light;

const int cLight = 255;


+ (CGPoint)relativeGridPosOfEntrance {
    return ccp(1,0);    
}

+ (CGPoint)relativeGridPosOfExit {
    return ccp(0,1);    
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

        id mainActionSequence = [CCSequence actions: [CCFadeOut actionWithDuration:0.1],[CCDelayTime actionWithDuration:1],  [CCCallFunc actionWithTarget:self selector:@selector(consume)], nil];
        [lastConsumedCapsule runAction:mainActionSequence];    
        return YES;
    }
    else {
        return NO;
    }
}

- (void)consume{
    
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
            id mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:1],  [CCCallFunc actionWithTarget:self selector:@selector(consume)], nil];
            [lastConsumedCapsule stopAllActions];
            [lastConsumedCapsule runAction:mainActionSequence];             
        }
    }
}


@end
