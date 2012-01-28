//
//  TowerBuilding.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Building.h"
@class Capsule;

@interface TowerBuilding : Building

@property (nonatomic, assign) unsigned int light;

+ (CGPoint)relativeGridPosOfEntrance;
+ (CGPoint)relativeGridPosOfExit;

- (BOOL)consumeCapsule:(Capsule*)capsule;
- (BOOL)isGridPosCapsuleEntrance:(CGPoint)gridPos;

@end
