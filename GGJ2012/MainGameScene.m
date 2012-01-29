//
//  MainGameScene.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MainGameScene.h"
#import "HelloWorldLayer.h"
#import "MapModel.h"
#import "PanGestureRecognizer.h"

@implementation MainGameScene {
    
    HelloWorldLayer *helloWorldLayer;
    
    UIView *addLightBuildingView;
    UIView *addMixBuildingView;    
    
    // Handling gesture
    PanGestureRecognizer *mainViewPanGestureRecognizer;
    CGPoint panStartPosition;
    CGPoint lastPanPosition;
}

@synthesize mainView;
@synthesize controlMode = _controlMode;

#pragma mark - Init

- (id)initWithMainView:(UIView*)initMainView addLightBuildingView:(UIView*)initAddLightBuildingView addMixBuildingView:(UIView*)initAddMixBuildingView {
    
    self = [super init];
    if (self) {
        
        mainView = initMainView;
        addLightBuildingView = initAddLightBuildingView;
        addMixBuildingView = initAddMixBuildingView;
        
        helloWorldLayer = [[HelloWorldLayer alloc] init];
        [self addChild:helloWorldLayer];

        // Gesture recognizers
        mainViewPanGestureRecognizer = [[PanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self.mainView addGestureRecognizer:mainViewPanGestureRecognizer];        
        
        PanGestureRecognizer *dragAndDropPanGestureRecognizer = [[PanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAndDropLightBuildingPanGestureRecognized:)];
        [addLightBuildingView addGestureRecognizer:dragAndDropPanGestureRecognizer];
        
        dragAndDropPanGestureRecognizer = [[PanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAndDropMixBuildingPanGestureRecognized:)];
        [addMixBuildingView addGestureRecognizer:dragAndDropPanGestureRecognizer];
        
        self.controlMode = ControlModePanning;       
    }
    
    return self;
}

#pragma mark - Setters

- (void)setControlMode:(ControlMode)newControlMode {
    
    _controlMode = newControlMode;
    
    switch (_controlMode) {
            
        case ControlModePanning:
            mainViewPanGestureRecognizer.enabled = YES;
            break;
            
        case ControlModeAddingMovers:
            mainViewPanGestureRecognizer.enabled = YES;
            break;
    }
}

#pragma mark - Gesture recognizers

- (void)panGestureRecognized:(PanGestureRecognizer*)gestureRecognizer {
    
    switch (_controlMode) {
            
        // Panning
        case ControlModePanning: {

            if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                
                panStartPosition = helloWorldLayer.position;
            }
            
            CGPoint translation = gestureRecognizer.translation;
            translation.y = -translation.y;
            
            helloWorldLayer.position = ccpAdd(panStartPosition, translation);            
            
            break;
        }
            
        // Adding movers
        case ControlModeAddingMovers: {
            
            if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                
                panStartPosition = helloWorldLayer.position;
            } 
            else {
                
                CGPoint lastGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(lastPanPosition, panStartPosition)];
                CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
                CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, panStartPosition)];
                
                if (lastGridPos.x - actualGridPos.x > 0.5) {
                    
                    for (int x = actualGridPos.x; x < lastGridPos.x; x++) {
                        [[MapModel sharedMapModel] addMover:MoverTypeLeft atGridPos:ccp(x + 1, lastGridPos.y)];
                    }
                }
                else if (lastGridPos.x - actualGridPos.x < -0.5) {

                    for (int x = lastGridPos.x; x < actualGridPos.x; x++) {
                        [[MapModel sharedMapModel] addMover:MoverTypeRight atGridPos:ccp(x, lastGridPos.y)];
                    }
                    
                }
                else if (lastGridPos.y - actualGridPos.y > 0.5) {
                    
                    for (int y = actualGridPos.y; y < lastGridPos.y; y++) {
                        [[MapModel sharedMapModel] addMover:MoverTypeUp atGridPos:ccp(lastGridPos.x, y + 1)];
                    }                    
                }
                else if (lastGridPos.y - actualGridPos.y < -0.5) {
                    
                    for (int y = lastGridPos.y; y < actualGridPos.y; y++) {
                        [[MapModel sharedMapModel] addMover:MoverTypeDown atGridPos:ccp(lastGridPos.x, y)];
                    }                        
                } 
                
                //NSLog(@"%@ %@", [NSValue valueWithCGPoint:lastGridPos], [NSValue valueWithCGPoint:actualGridPos]);
            }
            
            lastPanPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
            
            break;
        }
    }
}

- (void)dragAndDropMixBuildingPanGestureRecognized:(PanGestureRecognizer*)gestureRecognizer {

    // TODO
}

- (void)dragAndDropLightBuildingPanGestureRecognized:(PanGestureRecognizer*)gestureRecognizer {

    // TODO
}

@end
