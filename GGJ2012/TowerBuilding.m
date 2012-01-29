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
#import "Creeper.h"
#import "Lightning.h"

const float kMaxTowerBuffer = 7.0;
const int cTowerLight = 255;
const int cTowerLightRadius = 12;

const int kDefaultLight = 255;
const int kDefaultLightRadius = 4;

@interface TowerBuilding()

@property (nonatomic, assign) CapsuleComponents consumableCapsuleComponents;

@end


@implementation TowerBuilding {
    
    CCSprite *spriteComponent0;
    CCSprite *spriteComponent1;
    CCSprite *spriteComponent2;    
    
    float buffer;
    Capsule *lastConsumedCapsule;
    BOOL consuming;
    CCSequence *mainActionSequence;
    
    CGPoint lightningPoint;
}

@synthesize consumableCapsuleComponents;

+ (CGPoint)relativeGridPosOfEntrance {
    return ccp(0,-1);    
}

+ (CGPoint)relativeGridPosOfExit {
    return ccp(4,-1);    
}

-(id)initWithGID:(unsigned int)initGID andGridPos:(CGPoint)initGridPos  {
    
    if (self=[super initWithGID:initGID andGridPos:initGridPos]) {	
        
        self.defaultLightRadius = kDefaultLightRadius;
        self.defaultLight = kDefaultLight;
        
        self.light = cTowerLight;
        self.lightRadius = cTowerLightRadius;
        
        buffer = kMaxTowerBuffer;
        
        self.destroyable = YES;
        self.health = 100.0f;
        
        lightningPoint = ccpAdd([[MapModel sharedMapModel] tileCenterPositionForGripPos:initGridPos], ccp(70, 200));
        
        self.consumableCapsuleComponents = [[MapModel sharedMapModel] regionComponentsAtGridPos:self.gridPos];
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
    
    if (!CapsuleComponentsEquals(newCapsule.components, consumableCapsuleComponents)) {
 
        CGPoint gridPos = ccpAdd(self.gridPos, [TowerBuilding relativeGridPosOfEntrance]);
        Tile *tile = [[MapModel sharedMapModel]tileAtGridPos:gridPos];   
        tile.capsule = nil;
        
        [newCapsule stopAllActions];
        [newCapsule removeFromParentAndCleanup:YES];
        
        return NO;
    }
    
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
        buffer -= 1.0;
        if (!self.lightOn) {
            [self switchLight];
        }
        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:9], [CCCallFunc actionWithTarget:self selector:@selector(action)], nil];
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

        buffer += 1.0;
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

- (void)searchForCreep {
    if (! self.lightOn && buffer >= 1.0) {
        return;
    }
    
    Creeper* creeper = nil;
    
    for (creeper in [MapModel sharedMapModel].creepers) {
        if (ccpDistance(lightningPoint, creeper.position) < LUMINOSITY_TOWER_BUILDING_RADIUS * 50) {
            break;
        }
    }
    
    if (creeper) {
        buffer -= 1.0;
        
        Lightning* tempLightning = [[Lightning alloc] initWithStartPos:lightningPoint endPos:creeper.position];
        [[MapModel sharedMapModel].mainLayer addChild:tempLightning];

        [[MapModel sharedMapModel] killCreeper:creeper];
    }
}

- (void) onEnter {
    [super onEnter];
    
    [self schedule:@selector(searchForCreep) interval:1];
}

- (void)updateSpriteComponentsPositions {
    
    CGPoint center = [[MapModel sharedMapModel] tileCenterPositionForGripPos:self.gridPos];
    
    [spriteComponent0.parent reorderChild:spriteComponent0 z: -(self.gridPos.y  - 2)* 48];
    [spriteComponent1.parent reorderChild:spriteComponent1 z: -(self.gridPos.y  - 2)* 48];
    [spriteComponent2.parent reorderChild:spriteComponent2 z: -(self.gridPos.y  - 2)* 48];    
    
    spriteComponent0.position = ccpAdd(center, ccp(5, 171 - 66));
    spriteComponent1.position = ccpAdd(center, ccp(5, 170 - 45));        
    spriteComponent2.position = ccpAdd(center, ccp(5, 173 - 27));      
}

- (void)setConsumableCapsuleComponents:(CapsuleComponents)newConsumableCapsuleComponents {
    
    consumableCapsuleComponents = newConsumableCapsuleComponents;
    
    if (spriteComponent0) {
        [spriteComponent0 removeFromParentAndCleanup:NO];
    }
    if (spriteComponent1) {
        [spriteComponent1 removeFromParentAndCleanup:NO];
    }
    if (spriteComponent2) {
        [spriteComponent2 removeFromParentAndCleanup:NO];
    }
    
    spriteComponent0 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", consumableCapsuleComponents.component0]];
    spriteComponent1 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", consumableCapsuleComponents.component1]];
    spriteComponent2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", consumableCapsuleComponents.component2]];        
    
    [[MapModel sharedMapModel].mainLayer.spriteBatchNode addChild:spriteComponent0];
    [[MapModel sharedMapModel].mainLayer.spriteBatchNode addChild:spriteComponent1];     
    [[MapModel sharedMapModel].mainLayer.spriteBatchNode addChild:spriteComponent2]; 
    
    [self updateSpriteComponentsPositions];
}

- (void)hitWithDamage:(CGFloat)damage {
    buffer -= damage;
   // NSLog(@"Hitting tower with %.2f of %.4f", damage, buffer);
    
    if (buffer <= 0.0) {
       // NSLog(@"Destroying building");
        [[MapModel sharedMapModel] destroyBuildingAtPoint:self.gridPos];
    }
}

- (void)dealloc {
    [spriteComponent0 removeFromParentAndCleanup:YES];
    [spriteComponent1 removeFromParentAndCleanup:YES];
    [spriteComponent2 removeFromParentAndCleanup:YES];
}

@end
