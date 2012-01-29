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

const float kCreeperSpeed = 100;

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
		startColor.r = 1.00f;
		startColor.g = 1.00f;
		startColor.b = 1.00f;
		startColor.a = 1.00f;
		startColorVar.r = 0.00f;
		startColorVar.g = 0.00f;
		startColorVar.b = 0.00f;
		startColorVar.a = 0.00f;
		endColor.r = 1.00f;
		endColor.g = 1.00f;
		endColor.b = 1.00f;
		endColor.a = 0.00f;
		endColorVar.r = 0.00f;
		endColorVar.g = 0.00f;
		endColorVar.b = 0.00f;
		endColorVar.a = 0.00f;
        
        self.positionType = kCCPositionTypeRelative;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"particle.png"];
        
		// additive
		self.blendAdditive = NO;
       // self.blendFunc
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
    }
    
    return self;
}

- (void) tick
{
    if ([[MapModel sharedMapModel] isOutOfScreen:position_ size:CGSizeMake(50, 50)]) {
        if (self.body.active) {
            [self.body stopSystem];
          //  NSLog(@"Stopping particle system");
        }
    } else {
        if (! self.body.active) {
            [self.body resetSystem];
          //  NSLog(@"Starting particle system");
        }
    }
}

- (void) attack
{
    float minDistance = MAXFLOAT;
    CGPoint closestBuildingPosition;
    Building* closestBuilding = nil;
    
    for (Building* building in [MapModel sharedMapModel].buildings) {
        if (! building.destroyable) {
            continue;
        }
        
        CGRect buildingRect = [[MapModel sharedMapModel] gridRectForBuilding:building atGridPos:building.gridPos];
        
        CGPoint buildingPosition = [[MapModel sharedMapModel] 
            tileCenterPositionForGripPos:
                ccp(buildingRect.origin.x + buildingRect.size.width / 2, buildingRect.origin.y + buildingRect.size.height)
        ];
        
        CGFloat distance = ccpDistance(buildingPosition, self.position);
        
        if ( distance < minDistance) {
            closestBuildingPosition = buildingPosition;
            minDistance = distance;
            closestBuilding = building;
        }

    }
    
    if (! closestBuilding) {
        return;
    }
    
    if (minDistance < 50) {
        [closestBuilding hitWithDamage:5.0];
    }
    
    closestBuildingPosition.x += 50 * (rand() % 100 / 99.0f * 2 - 1);
    closestBuildingPosition.y += 50 * (rand() % 100 / 99.0f * 2 - 1);
    [self runAction:[CCMoveTo actionWithDuration:minDistance / kCreeperSpeed position:closestBuildingPosition]];
}

- (void) onEnter
{
    [super onEnter];
    
    [self schedule:@selector(tick)];
    [self schedule:@selector(attack) interval:1];
}

- (void) die 
{
    [self.body stopSystem];
    
    [self stopAllActions];
    [self unscheduleAllSelectors];
    
    [self.eyes runAction:[CCFadeOut actionWithDuration:1]];
    
    [self performSelector:@selector(dieAndRemove) withObject:nil afterDelay:2.0];
    }

- (void) dieAndRemove
{
    [self removeFromParentAndCleanup:YES];
}


@end
