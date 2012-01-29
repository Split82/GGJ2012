//
//  Creeper.h
//  GGJ2012
//
//  Created by Peter Morihladko on 28/01/2012.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "CCNode.h"
#import "CCSprite.h"
#import "CCParticleSystem.h"

@interface Creeper : CCNode

@property (nonatomic, strong) CCSprite* eyes;
@property (nonatomic, strong) CCParticleSystem* body;

- (id) initWithPos:(CGPoint) position;

- (void) tick;

@end
