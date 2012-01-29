//
//  HelloWorldLayer.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "MapModel.h"
#import "Capsule.h"
#import "Creeper.h"
#import "Lightning.h"

@implementation HelloWorldLayer {
    
    CCTMXTiledMap *map;
}
@synthesize spriteBatchNode;

- (id)init {

    self = [super init];

    if (self) {
        
        // Load sprites list
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"Sprites.plist"];
        
        spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.png"];        
        
		map = [CCTMXTiledMap tiledMapWithTMXFile:@"Map1.tmx"];
        
        [MapModel sharedMapModel].mainLayer = self;
        [[MapModel sharedMapModel] setMap:map];
        
		[self addChild:map];        
		
        [self addChild:spriteBatchNode];
	}
	return self;
}
@end
