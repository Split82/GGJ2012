//
//  MixerBuilding.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerBuilding.h"

@implementation MixerBuilding

@synthesize capsuleAtEntrance1;
@synthesize capsuleAtEntrance2;


+ (CGPoint)relativeGridPosOfEntrance1 {
    
    return ccp(1,1);
}
+ (CGPoint)relativeGridPosOfEntrance2 {

    return ccp(1,-1);
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

@end
