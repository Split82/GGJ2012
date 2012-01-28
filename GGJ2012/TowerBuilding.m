//
//  TowerBuilding.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "TowerBuilding.h"

@implementation TowerBuilding

@synthesize light;

const int cLight = 255;

-(id)initWithGID:(unsigned int)initGID andPos:(CGPoint)initPos  {
    if (self=[super initWithGID:initGID andPos:initPos]) {	
        light = cLight;
    }
    return self;    
}

@end
