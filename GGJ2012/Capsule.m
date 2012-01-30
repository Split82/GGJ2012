//
//  Capsule.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Capsule.h"
#import "MapModel.h"
#import "TowerBuilding.h"
#import "MixerBuilding.h"
#import "MineBuilding.h"
#import "Tile.h"

const float kMoveByActionDuration = 0.5;

@implementation Capsule {

    CCSprite *spriteComponent0;
    CCSprite *spriteComponent1;
    CCSprite *spriteComponent2;
    
    id nextActionCallFunc;
    id mainActionSequence;
    
    CGPoint lastMovement;
}

@synthesize components;

+ (id)moveToActionForMoveToGridPos:(CGPoint)moveToGridPos {
    
    // TODO
    return [CCMoveTo actionWithDuration:kMoveByActionDuration position:[[MapModel sharedMapModel] tileCenterPositionForGripPos:moveToGridPos]] ;
}

- (id)initWithComponents:(CapsuleComponents)initComponents {
    
    self = [super initWithSpriteFrameName:@"Capsule.png"];
    if (self) {
        
        self.components = initComponents;
        spriteComponent0 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", components.component0]];
        spriteComponent1 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", components.component1]];
        spriteComponent2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", components.component2]];        
        
        [self addChild:spriteComponent0];
        spriteComponent0.position = ccp(23, 89 - 66);
        [self addChild:spriteComponent1];
        spriteComponent1.position = ccp(23, 88 - 45);        
        [self addChild:spriteComponent2];
        spriteComponent2.position = ccp(23, 91 - 27);
        
        self.anchorPoint = ccp(0.5, 0);
        
        self.opacity = 255;
    }
    return self;
}

- (void)spawnAtGridPos:(CGPoint)newGridPos {

    self.position = [[MapModel sharedMapModel] tileCenterPositionForGripPos:newGridPos];
    
    nextActionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(doNextAction)];
    self.opacity = 0;
    mainActionSequence = [CCSequence actions:[CCFadeIn actionWithDuration:0.1],  nextActionCallFunc, nil]; 
    [self runAction:mainActionSequence]; 

}

- (void)doNextAction {

    // TODO Z
    
    [self.parent reorderChild:self z:-(int)self.position.y];
    
    CGPoint gridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:self.position];
    mainActionSequence = nil;
    Tile *currentTile = [[MapModel sharedMapModel]tileAtGridPos:gridPos];
    
    if (currentTile.isMover && !currentTile.building) {
        
        CGPoint moveGridVector = [currentTile nextGridMoveVectorForLastMoveGridVector:lastMovement]; 
        CGPoint nextGridPos = CGPointMake(gridPos.x + moveGridVector.x, gridPos.y + moveGridVector.y);
        Tile *nextTile = [[MapModel sharedMapModel]tileAtGridPos:nextGridPos];   
        if (nextTile.isFree) {
            lastMovement = moveGridVector;
            currentTile.capsule = nil;
            nextTile.capsule = self;
            mainActionSequence = [CCSequence actions: [Capsule moveToActionForMoveToGridPos:nextGridPos] , nextActionCallFunc, nil];            
        } 
        else {
            
            mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.1], nextActionCallFunc, nil];
        }
    } 
    if (!mainActionSequence && currentTile.building) {
        
        if ([currentTile.building isKindOfClass:[TowerBuilding class]]) {
            TowerBuilding *towerBuilding = (TowerBuilding*)currentTile.building;
            if ([towerBuilding isGridPosCapsuleEntrance:gridPos]) {
                if ([towerBuilding consumeCapsule:self]) {
                    return;
                    
                    if (currentTile.isSwitcher) {
                        [currentTile switchMover];
                    }

                } 
                else {
                    mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.1], nextActionCallFunc, nil];
                    
                }
            }
        }
        else if ([currentTile.building isKindOfClass:[MixerBuilding class]]) {
            MixerBuilding *mixerBuilding = (MixerBuilding*)currentTile.building;
            if ([mixerBuilding isGridPosCapsuleEntrance1:gridPos] || [mixerBuilding isGridPosCapsuleEntrance2:gridPos]) {
                if ([mixerBuilding consumeCapsule:self atGridPos:gridPos]) {               
                    return;
                    
                } 
                else {
                    mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.1], nextActionCallFunc, nil];
                    
                }
            }
        }
    }
    
    if (!mainActionSequence)  {
        currentTile.capsule = nil;

        mainActionSequence = [CCSequence actions: [CCFadeOut actionWithDuration:0.1],  [CCCallFunc actionWithTarget:self selector:@selector(destroy)], nil];
        [self runAction:mainActionSequence]; 
    }
    else {
        [self stopAllActions];
        [self runAction:mainActionSequence]; 

        
        if (currentTile.isSwitcher) {
            [currentTile switchMover];
        }
    }
    
}

#pragma mark - Dealloc

- (void)destroy {
    [self stopAllActions];
    [self removeFromParentAndCleanup:YES];
    return;    
}


@end
