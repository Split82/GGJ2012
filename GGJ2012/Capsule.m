//
//  Capsule.m
//  GGJ2012
//
//  Created by Peter Hrincar on 1/27/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Capsule.h"
#import "Tile.h"

@implementation Capsule {

    CCSprite *spriteComponent0;
    CCSprite *spriteComponent1;
    CCSprite *spriteComponent2;
}

@synthesize tile;
@synthesize components = _components;

- (id)initWithComponents:(CapsuleComponents)initComponents {
    
    self = [super initWithSpriteFrameName:@"Capsule.png"];
    if (self) {
        
        _components = initComponents;
        spriteComponent0 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", _components.component0]];
        spriteComponent1 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", _components.component1]];
        spriteComponent2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Component%d.png", _components.component2]];        
        
        [self addChild:spriteComponent0];
        spriteComponent0.position = ccp(12, 10);
        [self addChild:spriteComponent1];
        spriteComponent1.position = ccp(32, 10);        
        [self addChild:spriteComponent2];
        spriteComponent2.position = ccp(52, 10);        
    }
    return self;
}

@end
