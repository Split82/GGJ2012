//
//  Capsule.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//


typedef struct {
    int component0;
    int component1;
    int component2;
} CapsuleComponents;


@interface Capsule : CCSprite

@property (nonatomic, assign) CapsuleComponents components;

@end
