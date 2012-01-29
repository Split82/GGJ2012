//
//  Capsule.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//


@class Tile;

#import "CapsuleComponents.h"

@interface Capsule : CCSprite

@property (nonatomic, assign) CapsuleComponents components;

- (id)initWithComponents:(CapsuleComponents)initComponents;

- (void)spawnAtGridPos:(CGPoint)gridPos;

@end
