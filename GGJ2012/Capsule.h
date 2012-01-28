//
//  Capsule.h
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//


@class Tile;
typedef struct {
    int component0;
    int component1;
    int component2;
} CapsuleComponents;

static inline CapsuleComponents CapsuleComponentsMake(int component0, int component1, int component2) {
    
    CapsuleComponents capsuleComponents;
    capsuleComponents.component0 = component0;
    capsuleComponents.component1 = component1;
    capsuleComponents.component2 = component2;
    return capsuleComponents;
}


@interface Capsule : CCSprite

@property (nonatomic, weak) Tile* tile;
@property (nonatomic, assign) CapsuleComponents components;

- (id)initWithComponents:(CapsuleComponents)initComponents;

@end
