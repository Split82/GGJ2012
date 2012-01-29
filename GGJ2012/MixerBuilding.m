//
//  MixerBuilding.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerBuilding.h"
#import "MixerResult.h"
#import "MapModel.h"
#import "Capsule.h"


const int cMixerLight = 255;
const int cMixerLightRadius = 4;

@implementation MixerBuilding {
    BOOL busy;
    id mainActionSequence;
}

@synthesize capsuleAtEntrance1;
@synthesize capsuleAtEntrance2;

@synthesize result;


+ (CGPoint)relativeGridPosOfEntrance1 {

    return ccp(0,-1);
}

+ (CGPoint)relativeGridPosOfEntrance2 {

    return ccp(0,-3);
}

+ (CGPoint)relativeGridPosOfExit1 {
    return ccp(4,-1);    
}

+ (CGPoint)relativeGridPosOfExit2 {
    return ccp(4,-3);    
}

-(id)initWithGID:(unsigned int)initGID andGridPos:(CGPoint)initGridPos {
    if (self=[super initWithGID:initGID andGridPos:initGridPos])  {	
        
        self.light = cMixerLight;
        self.lightRadius = cMixerLightRadius;
        self.destroyable = YES;
        self.health = 100.0f;
    }
    return self;    
}


- (BOOL)isGridPosCapsuleEntrance1:(CGPoint)gridPos {
    if (CGPointEqualToPoint([MixerBuilding relativeGridPosOfEntrance1], ccpSub(gridPos, self.gridPos))) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isGridPosCapsuleEntrance2:(CGPoint)gridPos {
    if (CGPointEqualToPoint([MixerBuilding relativeGridPosOfEntrance2], ccpSub(gridPos, self.gridPos))) {
        return YES;
    }
    else {
        return NO;
    }
}

- (MixerResult *) result
{
    if (result == nil) {
        result = [[MixerResult alloc] init];
        [result setLeftInput:self.capsuleAtEntrance1.components];
        [result setRightInput:self.capsuleAtEntrance2.components];
        [result setLeftOutput:result.leftInput];
        [result setRightInput:result.rightInput];
    }
    return result;
}

-(int)capsuleComponentPartForIndex:(int)index {
    if (index > 2) {
        index -= 3;
        switch (index) {
            case 0:
                return capsuleAtEntrance2.components.component0;
                break;
            case 1:
                return capsuleAtEntrance2.components.component1;
                break;

            default:
            case 2:
                return capsuleAtEntrance2.components.component2;
                break;
        }
    }
    else {
        switch (index) {
            case 0:
                return capsuleAtEntrance1.components.component0;
                break;
            case 1:
                return capsuleAtEntrance1.components.component1;
                break;
                
            default:
            case 2:
                return capsuleAtEntrance1.components.component2;
                break;
        }        
    }
    
    return 0;
}

- (void)mix {
    
    CGPoint exitGridPos1 = ccpAdd(self.gridPos, [MixerBuilding relativeGridPosOfExit1]);
    CGPoint exitGridPos2 = ccpAdd(self.gridPos, [MixerBuilding relativeGridPosOfExit2]);
    
    Tile *nextExit1Tile = [[MapModel sharedMapModel]tileAtGridPos:exitGridPos1]; 
    Tile *nextExit2Tile = [[MapModel sharedMapModel]tileAtGridPos:exitGridPos2]; 
    
    if (nextExit1Tile.isFree && nextExit2Tile.isFree) {
        
        
        CGPoint capsuleAtEntranceGridPos1 = [[MapModel sharedMapModel] gridPosFromPixelPosition:capsuleAtEntrance1.position];
        CGPoint capsuleAtEntranceGridPos2 = [[MapModel sharedMapModel] gridPosFromPixelPosition:capsuleAtEntrance2.position];
        
        Tile *capsuleAtEntrance1Tile = [[MapModel sharedMapModel]tileAtGridPos:capsuleAtEntranceGridPos1]; 
        Tile *capsuleAtEntrance2Tile = [[MapModel sharedMapModel]tileAtGridPos:capsuleAtEntranceGridPos2]; 
        
        capsuleAtEntrance1Tile.capsule = nil;
        capsuleAtEntrance2Tile.capsule = nil;

        NSLog(@"%@",result.positions);
        CapsuleComponents c1, c2;
        c1 = CapsuleComponentsMake([self capsuleComponentPartForIndex:[[result.positions objectAtIndex:0 ] intValue]], [self capsuleComponentPartForIndex:[[result.positions objectAtIndex:1] intValue]], [self capsuleComponentPartForIndex:[[result.positions objectAtIndex:2] intValue]] );
        c2 = CapsuleComponentsMake([self capsuleComponentPartForIndex:[[result.positions objectAtIndex:3 ] intValue]], [self capsuleComponentPartForIndex:[[result.positions objectAtIndex:4] intValue]], [self capsuleComponentPartForIndex:[[result.positions objectAtIndex:5] intValue]] );
        
        
        Capsule *exitCapsule1 = [[Capsule alloc] initWithComponents:c1];
        Capsule *exitCapsule2 = [[Capsule alloc] initWithComponents:c2];
        
        [exitCapsule1 spawnAtGridPos:exitGridPos1];
        [[MapModel sharedMapModel].mainLayer.spriteBatchNode addChild:exitCapsule1];

        [exitCapsule2 spawnAtGridPos:exitGridPos2];
        [[MapModel sharedMapModel].mainLayer.spriteBatchNode addChild:exitCapsule2];
        
        
        [capsuleAtEntrance1 stopAllActions];
        [capsuleAtEntrance1 removeFromParentAndCleanup:YES];

        [capsuleAtEntrance2 stopAllActions];
        [capsuleAtEntrance2 removeFromParentAndCleanup:YES];
        

        capsuleAtEntrance1 = nil;
 
        capsuleAtEntrance2 = nil;
        
        busy = NO;
    } else {
        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.5], [CCCallFunc actionWithTarget:self selector:@selector(mix)], nil];
        [self runAction:mainActionSequence];
    }
}

- (BOOL)consumeCapsule:(Capsule*)capsule atGridPos:(CGPoint)gridPos {
    
    if (busy) {
        return NO;
    }
    BOOL ret = NO;
    if (!capsuleAtEntrance1 && [self isGridPosCapsuleEntrance1:gridPos]) {
        
        capsuleAtEntrance1 = capsule;
        [capsuleAtEntrance1 stopAllActions];
        
        ret =  YES;
    }
    else if (!capsuleAtEntrance2 && [self isGridPosCapsuleEntrance2:gridPos]) {
        
        capsuleAtEntrance2 = capsule;
        [capsuleAtEntrance2 stopAllActions];
        
        ret =  YES;
    }
    
    if (capsuleAtEntrance1 && capsuleAtEntrance2) {
        busy = YES;
        

        mainActionSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.5], [CCCallFunc actionWithTarget:self selector:@selector(mix)], nil];
        [self runAction:mainActionSequence];

    }
    
    return ret;
}
#pragma mark - Mixer delegate

- (void) viewController:(MixerViewController *)controller result:(MixerResult *)pResult
{
    result = pResult;
}

@end
