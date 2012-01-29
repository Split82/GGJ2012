//
//  Building.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Tile.h"



@interface Building : CCNode

@property (nonatomic, assign) CGPoint gridPos;
@property (nonatomic, assign) unsigned int gid;

@property (nonatomic, assign) unsigned int light;
@property (nonatomic, assign) BOOL lightOn;
@property (nonatomic, assign) CGPoint centerForLight;
@property (nonatomic, assign) unsigned int lightRadius;


+ (Building*)createBuildingFromGID:(unsigned int)gid andGridPos:(CGPoint)pos;

- (id)initWithGID:(unsigned int)gid andGridPos:(CGPoint)initPos;
- (void)switchLight;

- (BOOL)isFreeAtGridPos:(CGPoint)gridPos;

@end
