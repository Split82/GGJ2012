//
//  MineBuilding.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Building.h"
@class Tile;

@interface MineBuilding : Building

@property (nonatomic, weak)Tile *tile;

- (id)initWithGID:(unsigned int)gid;

@end
