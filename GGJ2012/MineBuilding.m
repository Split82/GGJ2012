//
//  MineBuilding.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MineBuilding.h"
#import "MapModel.h"
#import "Capsule.h"
#import "Tile.h"

@implementation MineBuilding {
    ccTime lastTimeMineProducedCapsule;
    CapsuleComponents capsuleComponents;
}

const ccTime timeScheduleInterval = 1; // in seconds
const ccTime mineTimeScheduleInterval = 2; // in seconds, when mine produced capsule

-(id)initWithGID:(unsigned int)initGID andPos:(CGPoint)initPos  {
    
    if (self=[super initWithGID:initGID andPos:initPos]) {	
        
        CapsuleComponentType capsuleComponentType;
        
        switch (self.gid) {
            case BuildingTypeMineWater:
                capsuleComponentType = CapsuleComponentTypeWater;
                break;
                
            case BuildingTypeMineFire:
                capsuleComponentType = CapsuleComponentTypeFire;
                break;
                
            case BuildingTypeMineEarth:
                capsuleComponentType = CapsuleComponentTypeEarth;
                break;
                
            case BuildingTypeMineWind:
                capsuleComponentType = CapsuleComponentTypeWind;
                break;
                
            default:
                capsuleComponentType = CapsuleComponentTypeEmpty;
                break;
                
        }
        
        capsuleComponents.component0 = capsuleComponentType;
        capsuleComponents.component1 = capsuleComponentType;
        capsuleComponents.component2 = capsuleComponentType;
        
        [self schedule:@selector(nextCalc:) interval:timeScheduleInterval];
        lastTimeMineProducedCapsule = 0;
    }
    return self;    
}

#pragma mark - Helpers

- (Capsule*)createCapsule {
    
    Capsule *capsule = [[Capsule alloc] initWithComponents:capsuleComponents];

    return capsule;
}

#pragma mark - Schedule

- (void)nextCalc:(ccTime)dt {
    lastTimeMineProducedCapsule += dt;
    if (lastTimeMineProducedCapsule > mineTimeScheduleInterval) {
        
        lastTimeMineProducedCapsule = 0;
        // TODO create capsule
        Capsule *capsule = [self createCapsule];
        [[MapModel sharedMapModel] tileAtPoint:self.pos].capsule = capsule;
        capsule.pos = ccp(self.pos.x + 1, self.pos.y);
        capsule.position = ccp(self.position.x + [MapModel sharedMapModel].tileSize.width ,self.position.y);

        [[MapModel sharedMapModel].mainLayer addChild:capsule];
    }
}

#pragma mark - Dealloc

- (void)destroy {
    
    [self unschedule:@selector(nextCalc:)];
}


@end
