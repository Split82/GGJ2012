//
//  MainGameScene.m
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MainGameScene.h"
#import "MapModel.h"
#import "PanGestureRecognizer.h"
#import "MixerBuilding.h"
#import "MixerViewController.h"

@implementation MainGameScene {
    
    UIView *addLightBuildingView;
    UIView *addMixBuildingView;    
    
    // Handling gesture
    PanGestureRecognizer *mainViewPanGestureRecognizer;
    CGPoint panStartPosition;
    CGPoint lastPanPosition;
    
    CCSprite *dragAndDropSprite;
}

@synthesize mainView;
@synthesize controlMode = _controlMode;
@synthesize helloWorldLayer;

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
        
        [self schedule:@selector(creeperSpawn:) interval:2];
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
            
        case ControlModeErasingMovers:
            mainViewPanGestureRecognizer.enabled = YES;
            break;
    }
}

#pragma mark - Helpers

- (void) presentMixerViewControllerForBuilding:(MixerBuilding *)building
{
    UIView *masterView = [[UIControl alloc] initWithFrame:mainView.bounds];
    [masterView setBackgroundColor:[UIColor clearColor]];
    [mainView addSubview:masterView];
    
    MixerViewController *controller = [[MixerViewController alloc] initWithResult:building.result];
    [controller setDelegate:building];
    __block CGRect frame = [controller frame];
    frame.origin.x = floorf((mainView.bounds.size.width - frame.size.width) / 2), 
    frame.origin.y = mainView.bounds.size.height;
    [controller setFrame:frame];
    [masterView addSubview:controller];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         [masterView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                         
                         frame.origin.y = floorf((mainView.bounds.size.height - frame.size.height) / 2);
                         [controller setFrame:frame];
                     }
                     completion:NULL];
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
            
            CGPoint resultPosition = ccpAdd(panStartPosition, translation);

            // add bounders
            resultPosition.x = MAX(MIN(0, resultPosition.x), -([MapModel sharedMapModel].map.contentSize.width - [[CCDirector sharedDirector] winSize].width));
            resultPosition.y = MAX(MIN(0, resultPosition.y), -([MapModel sharedMapModel].map.contentSize.height - [[CCDirector sharedDirector] winSize].height));
            
            helloWorldLayer.position = resultPosition;
            
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                
                // TAP
                if (gestureRecognizer.duration < 0.3 && ccpLengthSQ(gestureRecognizer.translation) < 25) {
                    
                    CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
                    CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, helloWorldLayer.position)];

                    if ([[[MapModel sharedMapModel] tileAtGridPos:actualGridPos].building isKindOfClass:[MixerBuilding class]]) {
                        
                        [self presentMixerViewControllerForBuilding:(id)[[MapModel sharedMapModel] tileAtGridPos:actualGridPos].building];
                    }
                }
            }
            
            break;
        }
            
        // Erasing movers
        case ControlModeErasingMovers: {
            

            CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
            CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, helloWorldLayer.position)];
            
            [[MapModel sharedMapModel] deleteMoverAtGridPos:ccp(actualGridPos.x, actualGridPos.y)];            
            
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

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // TODO call model and add building if possible
        CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
        CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, helloWorldLayer.position)];
        
        [[MapModel sharedMapModel] addBuilding:[Building createBuildingFromGID:TileTypeBuildingMixer andGridPos:actualGridPos] AtPoint:actualGridPos create:YES];

    }    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [dragAndDropSprite removeFromParentAndCleanup:NO];
        dragAndDropSprite = nil;
        return;
    }

    
    if (!dragAndDropSprite) {
        dragAndDropSprite = [[MapModel sharedMapModel] createMixerBuildingSprite];
        [helloWorldLayer addChild:dragAndDropSprite];
    }
    
    CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
    CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, helloWorldLayer.position)];
    
    dragAndDropSprite.position = [[MapModel sharedMapModel] tileCenterPositionForGripPos:actualGridPos];

}

- (void)dragAndDropLightBuildingPanGestureRecognized:(PanGestureRecognizer*)gestureRecognizer {

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // TODO call model and add building if possible
        
        CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
        CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, helloWorldLayer.position)];
        
        [[MapModel sharedMapModel] addBuilding:[Building createBuildingFromGID:TileTypeBuildingTowerDark andGridPos:actualGridPos] AtPoint:actualGridPos create:YES];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
       // NSLog(@"%@",gestureRecognizer  );
        [dragAndDropSprite removeFromParentAndCleanup:NO];
        dragAndDropSprite = nil;
        return;
    }
    
    
    if (!dragAndDropSprite) {
        dragAndDropSprite = [[MapModel sharedMapModel] createTowerBuildingSprite];
        [helloWorldLayer addChild:dragAndDropSprite];
    }
    
    CGPoint actualPosition = [[CCDirector sharedDirector] convertToGL:[gestureRecognizer locationInView:mainView]];
    CGPoint actualGridPos = [[MapModel sharedMapModel] gridPosFromPixelPosition:ccpSub(actualPosition, helloWorldLayer.position)];
    
    dragAndDropSprite.position = [[MapModel sharedMapModel] tileCenterPositionForGripPos:actualGridPos];
}

- (void)creeperSpawn:(ccTime)dt {
    [[MapModel sharedMapModel] spawnCreeperAtRandomBuilding];
    [[MapModel sharedMapModel] spawnCreeperAtRandomBuilding];
    [[MapModel sharedMapModel] spawnCreeperAtRandomBuilding];
}


@end
