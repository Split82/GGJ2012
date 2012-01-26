//
//  MainGameScene.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MainGameScene.h"
#import "HelloWorldLayer.h"

@implementation MainGameScene {
    
    HelloWorldLayer *helloWorldLayer;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];        
        
        helloWorldLayer = [[HelloWorldLayer alloc] init];
        [self addChild:helloWorldLayer];
    }
    
    return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];	
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
	
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
	
	CGPoint diff = ccpSub(touchLocation,prevLocation);
	
	CGPoint currentPos = [helloWorldLayer position];
	[helloWorldLayer setPosition: ccpAdd(currentPos, diff)];
}

@end
