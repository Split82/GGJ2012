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
const int cTowerLight = 200;
const int cTowerLightRadius = 7;

@implementation TowerBuilding {
    int buffer;
    Capsule *lastConsumedCapsule;
    BOOL consuming;
    CCSequence *mainActionSequence;
}




+ (CGPoint)relativeGridPosOfEntrance {
    return ccp(-1,0);    
}

+ (CGPoint)relativeGridPosOfExit {
    return ccp(1,0);    
}

-(id)initWithGID:(unsigned int)initGID andGridPos:(CGPoint)initGridPos  {
    if (self=[super initWithGID:initGID andGridPos:initGridPos]) {	
        self.light = cTowerLight;
        self.lightRadius = cTowerLightRadius;
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
        if (!self.lightOn) {
            [self switchLight];
        }
        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:10], [CCCallFunc actionWithTarget:self selector:@selector(action)], nil];
        [self runAction:mainActionSequence];    
        
    } else {
        if (self.lightOn) {
            [self switchLight];            
            mainActionSequence = nil;
        }
    }

}

- (void)consume{
    
    if (!mainActionSequence) {
        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(action)], nil];
        [self runAction:mainActionSequence];
    }
    
    CGPoint capsuleAtEntranceGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:lastConsumedCapsule.position];
    
    Tile *capsuleAtEntranceGridPosTile = [[MapModel sharedMapModel]tileAtGridPos:capsuleAtEntranceGridPos]; 
    

    
    if (buffer < kMaxTowerBuffer) {

        buffer ++;
        [lastConsumedCapsule stopAllActions];
        [lastConsumedCapsule removeFromParentAndCleanup:YES];
        consuming = NO;
        
        capsuleAtEntranceGridPosTile.capsule = nil;         
        
    }else {
        
        CGPoint endGridPos = ccpAdd(self.gridPos, [TowerBuilding relativeGridPosOfExit]);
        Tile *nextTile = [[MapModel sharedMapModel]tileAtGridPos:endGridPos];   
        if (nextTile.isFree) {   
            
            nextTile.capsule =  lastConsumedCapsule;
            [lastConsumedCapsule spawnAtGridPos:endGridPos];
                        
            lastConsumedCapsule = nil;
            consuming = NO;
            capsuleAtEntranceGridPosTile.capsule = nil; 
        } else {
            id capsuleActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:1],  [CCCallFunc actionWithTarget:self selector:@selector(consume)], nil];
            [lastConsumedCapsule stopAllActions];
            [lastConsumedCapsule runAction:capsuleActionSequence];             
        }
    }
}


@end
