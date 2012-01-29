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

@implementation HelloWorldLayer {
    
    CCTMXTiledMap *map;
}
@synthesize capsuleSpriteBatchNode;

- (id)init {

    self = [super init];

    if (self) {
        
		map = [CCTMXTiledMap tiledMapWithTMXFile:@"Map0.tmx"];
        
        [MapModel sharedMapModel].mainLayer = self;
        [[MapModel sharedMapModel] setMap:map];
        
		[self addChild:map];        
		
        
        // Load sprites list
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"Sprites.plist"];
        
        capsuleSpriteBatchNode = [CCSpriteBatchNode 
                                          batchNodeWithFile:@"Sprites.png"];
        
        
        [self addChild:capsuleSpriteBatchNode];
        
        // TODO delete creepers
        [[[MapModel sharedMapModel] spawnCreeperAtGridPos:ccp(0,53)] runAction:[CCMoveBy actionWithDuration:10 position:ccp(500, 500)]];
        [[[MapModel sharedMapModel] spawnCreeperAtGridPos:ccp(0,53)] runAction:[CCMoveBy actionWithDuration:9 position:ccp(400, 500)]];
        [[[MapModel sharedMapModel] spawnCreeperAtGridPos:ccp(0,53)] runAction:[CCMoveBy actionWithDuration:7 position:ccp(500, 300)]];
        [[[MapModel sharedMapModel] spawnCreeperAtGridPos:ccp(0,53)] runAction:[CCMoveBy actionWithDuration:8 position:ccp(450, 500)]];
        [[[MapModel sharedMapModel] spawnCreeperAtGridPos:ccp(0,53)] runAction:[CCMoveBy actionWithDuration:10 position:ccp(300, 500)]];
        
	}
	return self;
}

@end
