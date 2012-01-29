//
//  MainGameScene.h
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "HelloWorldLayer.h"

typedef enum {
    
    ControlModePanning,
    ControlModeAddingMovers,
    ControlModeErasingMovers
} ControlMode;

@interface MainGameScene : CCScene

@property (nonatomic, readonly, strong) UIView *mainView;
@property (nonatomic, readonly, strong) HelloWorldLayer *helloWorldLayer;

@property (nonatomic, assign) ControlMode controlMode;

- (id)initWithMainView:(UIView*)mainView addLightBuildingView:(UIView*)addLightBuildingView addMixBuildingView:(UIView*)addMixBuildingView;
- (void)panGestureRecognized:(UIPanGestureRecognizer*)panGestureRecognizer;

@end
