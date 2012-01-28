//
//  MixerCircleView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerView.h"
#import "MixerCircleView.h"
#import "KTOneFingerRotationGestureRecognizer.h"
#import "MixerPlanView.h"


#define kMixerPlanMaxNumber     8


@interface MixerView ()

- (void) setTransform:(CGAffineTransform)transform toView:(MixerCircleView *)view;
- (void) handleRotationWithView:(MixerCircleView *)view gesture:(UIRotationGestureRecognizer *)gesture;
@property (nonatomic, assign) CGAffineTransform rotationTransform;

- (void) topTapGesture:(UITapGestureRecognizer *)sender;
- (void) topAction:(int)direction;

- (void) bottomTapGesture:(UITapGestureRecognizer *)sender;
- (void) bottomAction:(int)direction;

@property (nonatomic, assign) NSInteger lastPlanIndex;
@property (nonatomic, assign) int steps;

@end

@implementation MixerView

@synthesize leftComponent = _leftComponent;
@synthesize rigtComponent = _rigtComponent;
@synthesize rotationTransform = _rotationTransform;

@synthesize topCircleView = _topCircleView;
@synthesize bottomCircleView = _bottomCircleView;

@synthesize planViews = _planViews;
@synthesize lastPlanIndex = _lastPlanIndex;
@synthesize steps = _steps;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent
{
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 300.0, 600.0)];
    
    if (self) {
        [self setLeftComponent:leftComponent rightComponent:rigtComponent];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        UIRotationGestureRecognizer *rotationGesture = nil;
        KTOneFingerRotationGestureRecognizer *oneTapRotation = nil;
        UITapGestureRecognizer *tapGesture = nil;
        
        _topCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, 80.0, 300.0, 300.0)];
        [_topCircleView setBackgroundColor:[UIColor clearColor]];
        [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
        [self addSubview:_topCircleView];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTapGesture:)];
        [tapGesture setNumberOfTapsRequired:1];
        [_topCircleView addGestureRecognizer:tapGesture];
        
        oneTapRotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(topGesture:)];
        [oneTapRotation requireGestureRecognizerToFail:tapGesture];
        [_topCircleView addGestureRecognizer:oneTapRotation];
        
        rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(topGesture:)];
        [rotationGesture requireGestureRecognizerToFail:tapGesture];
        [rotationGesture requireGestureRecognizerToFail:oneTapRotation];
        [_topCircleView addGestureRecognizer:rotationGesture];
        
        _bottomCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_topCircleView.frame) - 149.0, 300.0, 300.0)];
        [_bottomCircleView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_bottomCircleView belowSubview:_topCircleView];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomTapGesture:)];
        [tapGesture setNumberOfTapsRequired:1];
        [_bottomCircleView addGestureRecognizer:tapGesture];
        
        oneTapRotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
        [oneTapRotation requireGestureRecognizerToFail:tapGesture];
        [_bottomCircleView addGestureRecognizer:oneTapRotation];
        
        rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
        [rotationGesture requireGestureRecognizerToFail:tapGesture];
        [rotationGesture requireGestureRecognizerToFail:oneTapRotation];
        [_bottomCircleView addGestureRecognizer:rotationGesture];
        
        CGFloat originX = 186.0;
        _planViews = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < kMixerPlanMaxNumber; i++) {
            MixerPlanView *imageView = [[MixerPlanView alloc] initWithFrame:CGRectMake(originX + i * 83.0, 
                                                                                       CGRectGetMaxY(_bottomCircleView.frame) + 65.0, 
                                                                                       80.0, 80.0)];
            [imageView setBackgroundImage:[UIImage imageNamed:@"MixerCricleEmpty"] forState:UIControlStateNormal];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [self addSubview:imageView];
            [_planViews addObject:imageView];
        }
    }
    return self;
}
        
#pragma mark -

- (void) setLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent
{
    _leftComponent = leftComponent;
    _rigtComponent = rigtComponent;
    
    MixerViewNumbers numbers0;
    numbers0.component00 = _leftComponent.component0;
    numbers0.component01 = _rigtComponent.component0;
    numbers0.component10 = _leftComponent.component1;
    numbers0.component11 = _rigtComponent.component1;
    
    [_topCircleView setNumbers:numbers0];
    [_topCircleView setup];
    [_topCircleView setMode:MixerCircleViewModesFull];
    
    MixerViewNumbers numbers1;
    numbers1.component00 = _leftComponent.component1;
    numbers1.component01 = _rigtComponent.component1;
    numbers1.component10 = _leftComponent.component2;
    numbers1.component11 = _rigtComponent.component2;
    
    [_bottomCircleView setNumbers:numbers1];
    [_bottomCircleView setup];
    [_bottomCircleView setMode:MixerCircleViewModesFull];
}

- (void) reset
{
    [self setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0)) toView:_topCircleView];
    [self setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(180)) toView:_bottomCircleView];
    
    [self setLeftComponent:_leftComponent rightComponent:_rigtComponent];
    
    _lastPlanIndex = 0;
    for (MixerPlanView *imageView in _planViews) {
        [imageView setBackgroundImage:[UIImage imageNamed:@"MixerCricleEmpty"] forState:UIControlStateNormal];
        [imageView setSteps:0];
    }
}

#pragma mark - Rotation

- (void) topAction:(int)direction
{
    //[UIView beginAnimations:nil context:NULL];
    MixerViewNumbers numbers;
    
    if (direction < 0) {
        numbers.component00 = _topCircleView.numbers.component01;
        numbers.component01 = _topCircleView.numbers.component11;
        numbers.component10 = _topCircleView.numbers.component00;
        numbers.component11 = _topCircleView.numbers.component10;
        [_topCircleView setNumbers:numbers];
    } else {
        numbers.component00 = _topCircleView.numbers.component10;
        numbers.component01 = _topCircleView.numbers.component00;
        numbers.component10 = _topCircleView.numbers.component11;
        numbers.component11 = _topCircleView.numbers.component01;
        [_topCircleView setNumbers:numbers];
    }
    numbers = [_bottomCircleView numbers];
    numbers.component00 = _topCircleView.numbers.component10;
    numbers.component01 = _topCircleView.numbers.component11;
    [_bottomCircleView setNumbers:numbers];
    //[UIView commitAnimations];
}

- (void) topTapGesture:(UITapGestureRecognizer *)sender
{
    [self bringSubviewToFront:_topCircleView];
    [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
    [_bottomCircleView.background setImage:[UIImage imageNamed:@"kolo_bg"]];
}

- (void) topGesture:(UIRotationGestureRecognizer *)sender
{
    [self handleRotationWithView:_topCircleView gesture:sender];
}

- (void) bottomAction:(int)direction
{
    MixerViewNumbers numbers;
    
    if (direction < 0) {
        numbers.component00 = _bottomCircleView.numbers.component01;
        numbers.component01 = _bottomCircleView.numbers.component11;
        numbers.component10 = _bottomCircleView.numbers.component00;
        numbers.component11 = _bottomCircleView.numbers.component10;
        [_bottomCircleView setNumbers:numbers];
    } else {
        numbers.component00 = _bottomCircleView.numbers.component10;
        numbers.component01 = _bottomCircleView.numbers.component00;
        numbers.component10 = _bottomCircleView.numbers.component11;
        numbers.component11 = _bottomCircleView.numbers.component01;
        [_bottomCircleView setNumbers:numbers];
    }
    numbers = [_topCircleView numbers];
    numbers.component10 = _bottomCircleView.numbers.component00;
    numbers.component11 = _bottomCircleView.numbers.component01;
    [_topCircleView setNumbers:numbers];
}

- (void) bottomTapGesture:(UITapGestureRecognizer *)sender
{
    [self bringSubviewToFront:_bottomCircleView];
    [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_bg"]];
    [_bottomCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
}

- (void) bottomGesture:(UIRotationGestureRecognizer *)sender
{
    [self handleRotationWithView:_bottomCircleView gesture:sender];
}

- (void) handleRotationWithView:(MixerCircleView *)view gesture:(UIRotationGestureRecognizer *)gesture
{
    if (_lastPlanIndex == kMixerPlanMaxNumber)
        return;
    __block int degress = CC_RADIANS_TO_DEGREES([gesture rotation]);
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        // save start rotation
        [self setRotationTransform:view.background.transform];
        [self bringSubviewToFront:view];
        
        if (view == _topCircleView) {
            [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
            [_bottomCircleView.background setImage:[UIImage imageNamed:@"kolo_bg"]];
        } else {
            [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_bg"]];
            [_bottomCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
        }
        [self setSteps:0];
    } else if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
        if ((degress < 45 && degress > 0) || (degress > -45 && degress < 0)) {
            // reset back
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut
                             animations:^(void) {
                                 [self setTransform:self.rotationTransform toView:view];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            // move to next/prev
            __block int direction = ([gesture rotation] > 0 ? 1 : -1);
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseIn
                             animations:^(void) {
                                 degress = degress % 360;
                                 CGAffineTransform transform = CGAffineTransformRotate(self.rotationTransform, 
                                                                                       CC_DEGREES_TO_RADIANS(roundf((float)degress / 90) * 90));
                                 [self setTransform:transform toView:view];
                             }
                             completion:^(BOOL finished) {
                                 MixerPlanView *imageView = [_planViews objectAtIndex:_lastPlanIndex];
                                 [self setSteps:roundf((float)degress / 90)];
                                 
                                 if (_lastPlanIndex > 0 && (([[_planViews objectAtIndex:_lastPlanIndex - 1] topView] && view == _topCircleView) 
                                                            || (![[_planViews objectAtIndex:_lastPlanIndex - 1] topView] && view == _bottomCircleView))) {
                                     imageView = [_planViews objectAtIndex:_lastPlanIndex - 1];
                                 } else {
                                     [imageView setSteps:0];
                                    _lastPlanIndex++;
                                 }
                                 
                                 if (view == _topCircleView) {
                                     for (int i = 0; i < self.steps; i++) {
                                         [self topAction:direction];
                                     }
                                     [imageView setSteps:imageView.steps + self.steps];
                                     if ([imageView steps] > 4) 
                                         [imageView setSteps:4];
                                     else if ([imageView steps] < -4)
                                         [imageView setSteps:-4];
                                     [imageView setBackgroundImage:[UIImage imageNamed:imageView.steps > 0 ? 
                                                                    @"MixerCricleDown" : @"MixerCricleDown2"]
                                                          forState:UIControlStateNormal];
                                     [imageView setTopView:YES];
                                     
                                     if ([imageView steps] == 0) {
                                         [imageView setBackgroundImage:[UIImage imageNamed:@"MixerCricleEmpty"] forState:UIControlStateNormal];
                                         _lastPlanIndex--;
                                     }
                                 } else {
                                     for (int i = 0; i < self.steps; i++) {
                                         [self bottomAction:direction];
                                     }
                                     [imageView setSteps:imageView.steps + self.steps];
                                     if ([imageView steps] > 4) 
                                         [imageView setSteps:4];
                                     else if ([imageView steps] < -4)
                                         [imageView setSteps:-4];
                                     [imageView setBackgroundImage:[UIImage imageNamed:imageView.steps > 0 ? 
                                                                    @"MixerCricleUp2" : @"MixerCricleUp"] 
                                                          forState:UIControlStateNormal];
                                     [imageView setTopView:NO];
                                     
                                     if ([imageView steps] == 0) {
                                         [imageView setBackgroundImage:[UIImage imageNamed:@"MixerCricleEmpty"] forState:UIControlStateNormal];
                                         _lastPlanIndex--;
                                     }
                                 }
                             }];
            [gesture setEnabled:YES];
        }
    } else {
        CGAffineTransform transform = CGAffineTransformRotate(self.rotationTransform, [gesture rotation]);
        [self setTransform:transform toView:view];
    }
}

- (void) setTransform:(CGAffineTransform)transform toView:(MixerCircleView *)view
{
    [view.background setTransform:transform];
    
    for (int i = 1; i < 5; i++) {
        [[view viewWithTag:i] setTransform:transform];
    }
}
 
@end
