//
//  TowerBuilding.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Building.h"

@interface TowerBuilding : Building

@property (nonatomic, assign) unsigned int light;

-(id)initWithGID:(unsigned int)gid andPos:(CGPoint)initPos;

@end
