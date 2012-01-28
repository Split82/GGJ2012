//
//  MainGameScene.h
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/26/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

typedef enum {
    
    ControlModePanning,
    ControlModeAddingMovers,
} ControlMode;

@interface MainGameScene : CCScene

@property (nonatomic, readonly, strong) UIView *mainView;

@property (nonatomic, assign) ControlMode controlMode;

- (id)initWithMainView:(UIView*)mainView;
- (void)panGestureRecognized:(UIPanGestureRecognizer*)panGestureRecognizer;

@end
