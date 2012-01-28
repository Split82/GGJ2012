//
//  Capsule.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Capsule.h"
#import "MapModel.h"
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
        spriteComponent0.position = ccp(12, 10);
        [self addChild:spriteComponent1];
        spriteComponent1.position = ccp(32, 10);        
        [self addChild:spriteComponent2];
        spriteComponent2.position = ccp(52, 10);    
        
    
        
    }
    return self;
}

- (void)spawnAtGridPos:(CGPoint)newGridPos {

    self.position = [[MapModel sharedMapModel] tileCenterPositionForGripPos:newGridPos];
    
    nextActionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(doNextAction)];

    mainActionSequence = [CCSequence actions: nextActionCallFunc, nil]; 
    [self runAction:mainActionSequence]; 

}

- (void)doNextAction {

     CGPoint gridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:self.position];
     
    Tile *currentTile = [[MapModel sharedMapModel]tileAtGridPos:gridPos];
    if (currentTile.isMover) {
        
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
            
            mainActionSequence = [CCSequence actions: [Capsule moveToActionForMoveToGridPos:gridPos], nextActionCallFunc, nil];
        }
    } 
    else {
       
        mainActionSequence = [CCSequence actions: [Capsule moveToActionForMoveToGridPos:gridPos], nextActionCallFunc, nil];
    }
    
    [self runAction:mainActionSequence]; 

}

#pragma mark - Dealloc

- (void)destroy {
    
}


@end
