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

@implementation Capsule {

    CCSprite *spriteComponent0;
    CCSprite *spriteComponent1;
    CCSprite *spriteComponent2;
    
    id nextActionCallFunc;
    id mainActionSequence;
}

@synthesize components;
@synthesize pos;
@synthesize r;


+ (id)actionMoveBy:(CGPoint)r {
    // TODO Static
    return [CCMoveBy actionWithDuration: 1 position: ccp(r.x  * [MapModel sharedMapModel].tileSize.width ,r.y  * [MapModel sharedMapModel].tileSize.height)];
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
        
        
        nextActionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(doNextAction)];
 
        mainActionSequence = [CCSequence actions: [Capsule actionMoveBy:CGPointMake(1, 0)], nextActionCallFunc, nil];
        [self runAction:mainActionSequence]; 
        
    }
    return self;
}


- (void)doNextAction {

    Tile *myTile = [[MapModel sharedMapModel] tileAtPoint:pos];

    pos = [[MapModel sharedMapModel] posFromPixelPosition:self.position];
    Tile *tile = [[MapModel sharedMapModel] tileAtPoint:pos];
    CGPoint newR = [tile nextMove:self.r];
    Tile *nextTile = [[MapModel sharedMapModel] tileAtPoint:CGPointMake(self.pos.x + newR.x, self.pos.y + newR.y)];
    if ([nextTile isFree]) {
        r = newR;
        nextTile.capsule = self;
        myTile.capsule = nil;
        mainActionSequence = [CCSequence actions: [Capsule actionMoveBy:r], nextActionCallFunc, nil];
    }else {
        mainActionSequence = [CCSequence actions: [Capsule actionMoveBy:CGPointMake(0, 0)], nextActionCallFunc, nil];

        //TODO
    }
    [self runAction:mainActionSequence]; 

}

#pragma mark - Dealloc

- (void)destroy {
    
}


@end
