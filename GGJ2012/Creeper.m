//
//  Creeper.m
//  GGJ2012
//
//  Created by Peter Morihladko on 28/01/2012.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "Creeper.h"
#import "MapModel.h"

#import "CCParticleSystemQuad.h"

@interface CreeperBodyParticleSystem : CCParticleSystemQuad {
    
}
@end

@implementation CreeperBodyParticleSystem
-(id) init
{
	return [self initWithTotalParticles:120];
}

-(id) initWithTotalParticles:(NSUInteger) p
{
	if( (self=[super initWithTotalParticles:p]) ) {
        
		// duration
		duration = kCCParticleDurationInfinity;
        
		// Gravity Mode
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(0,0);
		
		// Gravity Mode: speed of particles
		self.speed = 40;
		self.speedVar = 5;
		
		// Gravity Mode: radial
		self.radialAccel = -60;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 15;
		self.tangentialAccelVar = 0;
        
		// angle
		angle = 90;
		angleVar = 360;
		
		// emitter position
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.position = ccp(winSize.width/2, winSize.height/2);
		posVar = CGPointZero;
		
		// life of particles
		life = 0.5f;
		lifeVar = 0.1f;
		
		// size, in pixels
		startSize = 10.0f;
		startSizeVar = 5.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
        
		// emits per second
		emissionRate = totalParticles/life;
		
		// color of particles
		startColor.r = 0.50f;
		startColor.g = 0.50f;
		startColor.b = 0.50f;
		startColor.a = 1.0f;
		startColorVar.r = 0.5f;
		startColorVar.g = 0.5f;
		startColorVar.b = 0.5f;
		startColorVar.a = 0.5f;
		endColor.r = 0.0f;
		endColor.g = 0.0f;
		endColor.b = 0.0f;
		endColor.a = 1.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
        
        self.positionType = kCCPositionTypeRelative;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
        
		// additive
		self.blendAdditive = YES;
	}
    
	return self;
}
@end

@implementation Creeper

@synthesize eyes;
@synthesize body;

- (id) init 
{
    return [self initWithPos:ccp(0, 0)];
}

- (id) initWithPos:(CGPoint) position
{
    self = [super init];
    
    if (self) {
        self.position = position;
        
        self.eyes = [[CCSprite alloc] initWithFile:@"creeper.png"];
        self.eyes.position = ccp(0,0);
        
        self.body = [[CreeperBodyParticleSystem alloc] init];
        self.body.position = ccp(0,0);        
        
        [self addChild:self.eyes z:2];
        [self addChild:self.body z:1];
        
        [self schedule:@selector(tick)];
    }
    
    return self;
}

- (void) tick
{
    if ([[MapModel sharedMapModel] isOutOfScreen:position_ size:CGSizeMake(50, 50)]) {
        if (self.body.active) {
            [self.body stopSystem];
            NSLog(@"Stopping particle system");
        }
    } else {
        if (! self.body.active) {
            [self.body resetSystem];
            NSLog(@"Starting particle system");
        }
    }
}



@end
