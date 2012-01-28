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

@implementation MainGameScene {
    
    HelloWorldLayer *helloWorldLayer;
    
    // Handling gesture
    UIPanGestureRecognizer *panGestureRecognizer;
    CGPoint panStartPosition;
    CGPoint lastPanPosition;
}

@synthesize mainView;
@synthesize controlMode = _controlMode;

#pragma mark - Init

- (id)initWithMainView:(UIView*)initMainView {
    
    self = [super init];
    if (self) {
        
        mainView = initMainView;
        
        helloWorldLayer = [[HelloWorldLayer alloc] init];
        [self addChild:helloWorldLayer];

        // Gesture recognizers
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self.mainView addGestureRecognizer:panGestureRecognizer];        
        
        self.controlMode = ControlModePanning;       
    }
    
    return self;
}

#pragma mark - Setters

- (void)setControlMode:(ControlMode)newControlMode {
    
    _controlMode = newControlMode;
    
    switch (_controlMode) {
            
        case ControlModePanning:
            panGestureRecognizer.enabled = YES;
            break;
            
        case ControlModeAddingMovers:
            panGestureRecognizer.enabled = YES;
            break;
    }
}

#pragma mark - Gesture recognizers

- (void)panGestureRecognized:(UIPanGestureRecognizer*)gestureRecognizer {
    
    switch (_controlMode) {
            
        // Panning
        case ControlModePanning: {

            if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                
                panStartPosition = helloWorldLayer.position;
            }
            
            CGPoint translation = [gestureRecognizer translationInView:mainView];
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
                    [[MapModel sharedMapModel] addMover:MoverTypeLeft atGridPos:lastGridPos];
                }
                else if (lastGridPos.x - actualGridPos.x < -0.5) {
                    [[MapModel sharedMapModel] addMover:MoverTypeRight atGridPos:lastGridPos];                    
                }
                else if (lastGridPos.y - actualGridPos.y > 0.5) {
                    [[MapModel sharedMapModel] addMover:MoverTypeMoverUp atGridPos:lastGridPos];                    
                }
                else if (lastGridPos.y - actualGridPos.y < -0.5) {
                    [[MapModel sharedMapModel] addMover:MoverTypeMoverDown atGridPos:lastGridPos];                    
                } 
                
                NSLog(@"%@ %@", [NSValue valueWithCGPoint:lastGridPos], [NSValue valueWithCGPoint:actualGridPos]);
            }
            
            lastPanPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
            
            break;
        }
    }
    

}

@end
