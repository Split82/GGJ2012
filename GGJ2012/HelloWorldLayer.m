//
//  HelloWorldLayer.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "Capsule.h"

@implementation HelloWorldLayer {
    
    CCTMXTiledMap *map;
}

- (id)init {

    self = [super init];

    if (self) {
        
		map = [CCTMXTiledMap tiledMapWithTMXFile:@"Map0.tmx"];
		[self addChild:map];        
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        id moveDown = [CCMoveBy actionWithDuration:1.0 position:ccp(0, 50)];
        moveDown = [CCEaseInOut actionWithAction:moveDown rate:2];
        id moveUp = [moveDown reverse];
        id action = [CCRepeatForever actionWithAction:[CCSequence actions:moveDown, moveUp, nil]];
        [label runAction:action];
        
        // Load sprites list
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"Sprites.plist"];
        
        CCSpriteBatchNode *capsuleSprites = [CCSpriteBatchNode 
                                          batchNodeWithFile:@"Sprites.png"];
        [self addChild:capsuleSprites];
        
        Capsule *capsule = [[Capsule alloc] initWithComponents:CapsuleComponentsMake(0, 0, 0)];
        [capsuleSprites addChild:capsule];

        capsule.position = ccp(50, 100);
	}
	return self;
}

@end
