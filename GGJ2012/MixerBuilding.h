//
//  MixerBuilding.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Building.h"
@class Capsule;

@interface MixerBuilding : Building

@property (nonatomic, strong) Capsule *capsuleAtEntrance1;
@property (nonatomic, strong) Capsule *capsuleAtEntrance2;

+ (CGPoint)relativeGridPosOfEntrance1;
+ (CGPoint)relativeGridPosOfEntrance2;

+ (CGPoint)relativeGridPosOfExit1;
+ (CGPoint)relativeGridPosOfExit2;

- (BOOL)isGridPosCapsuleEntrance1:(CGPoint)gridPos;
- (BOOL)isGridPosCapsuleEntrance2:(CGPoint)gridPos;

- (BOOL)consumeCapsule:(Capsule*)capsule atGridPos:(CGPoint)gridPos;

@end
