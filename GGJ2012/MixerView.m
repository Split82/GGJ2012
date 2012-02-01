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
- (void) animatateStep:(MixerPlanView *)step fromView:(UIView *)view;
- (void) handleRotationWithView:(MixerCircleView *)view gesture:(UIRotationGestureRecognizer *)gesture;
@property (nonatomic, assign) CGAffineTransform rotationTransform;
@property (nonatomic, assign) BOOL changed;

- (void) topTapGesture:(UITapGestureRecognizer *)sender;
- (void) topAction:(int)direction;

- (void) bottomTapGesture:(UITapGestureRecognizer *)sender;
- (void) bottomAction:(int)direction;

@property (nonatomic, assign) NSInteger lastPlanIndex;
@property (nonatomic, assign) int steps;

@end

@implementation MixerView

@synthesize topPos = _topPos;
@synthesize bottomPos = _bottomPos;

@synthesize leftComponent = _leftComponent;
@synthesize rigtComponent = _rigtComponent;
@synthesize rotationTransform = _rotationTransform;
@synthesize changed = _changed;

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
        //UIRotationGestureRecognizer *rotationGesture = nil;
        KTOneFingerRotationGestureRecognizer *oneTapRotation = nil;
        
        _topCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, 80.0, 300.0, 300.0)];
        [_topCircleView setBackgroundColor:[UIColor clearColor]];
        [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
        [self addSubview:_topCircleView];
        
        oneTapRotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(topGesture:)];
        [_topCircleView addGestureRecognizer:oneTapRotation];
        
        /*rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(topGesture:)];
        [rotationGesture requireGestureRecognizerToFail:oneTapRotation];
        [_topCircleView addGestureRecognizer:rotationGesture];*/
        
        _bottomCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_topCircleView.frame) - 149.0, 300.0, 300.0)];
        [_bottomCircleView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_bottomCircleView belowSubview:_topCircleView];
        
        oneTapRotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
        [_bottomCircleView addGestureRecognizer:oneTapRotation];
        
        /*rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
        [rotationGesture requireGestureRecognizerToFail:oneTapRotation];
        [_bottomCircleView addGestureRecognizer:rotationGesture];*/
        
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

- (void) setup
{
    MixerViewNumbers numbers0;
    numbers0.component00 = _leftComponent.component0;
    numbers0.component01 = _rigtComponent.component0;
    numbers0.component10 = _leftComponent.component1;
    numbers0.component11 = _rigtComponent.component1;
    
    [_topCircleView setNumbers:numbers0];
    [_topCircleView setup];
    
    MixerViewNumbers numbers1;
    numbers1.component00 = _leftComponent.component1;
    numbers1.component01 = _rigtComponent.component1;
    numbers1.component10 = _leftComponent.component2;
    numbers1.component11 = _rigtComponent.component2;
    
    [_bottomCircleView setNumbers:numbers1];
    [_bottomCircleView setup];
}

- (void) setLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent
{
    _leftComponent = leftComponent;
    _rigtComponent = rigtComponent;
    
    _topPos.component00 = 0;
    _topPos.component01 = 3;
    _topPos.component10 = 1;
    _topPos.component11 = 4;
    
    _bottomPos.component00 = 1;
    _bottomPos.component01 = 4;
    _bottomPos.component10 = 2;
    _bottomPos.component11 = 5;
    
    [self setup];
}

- (void) setLeftComponent:(CapsuleComponents)leftComponent
{
    _leftComponent = leftComponent;
    [self setup];
}

- (void) setRigtComponent:(CapsuleComponents)rigtComponent
{
    _rigtComponent = rigtComponent;
    [self setup];
}

- (void) reset
{
    [self setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0)) toView:_topCircleView];
    [self setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0)) toView:_bottomCircleView];
    
    [self setLeftComponent:_leftComponent rightComponent:_rigtComponent];
    _lastPlanIndex = 0;
    
    for (MixerPlanView *imageView in _planViews) {
        [imageView setBackgroundImage:[UIImage imageNamed:@"MixerCricleEmpty"] forState:UIControlStateNormal];
        [imageView setSteps:0];
    }
}

- (NSMutableArray *) allSteps
{
    NSMutableArray *steps = [NSMutableArray array];
    
    for (MixerPlanView *view in _planViews) {
        if ([view steps] == 0) continue;
        [steps addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:view.direction], @"direction", 
                          [NSNumber numberWithInt:view.steps], @"count", nil]];
    }
    return steps;
}

- (void) setAllSteps:(NSMutableArray *)array
{
    [self reset];
    
    for (NSDictionary *step in array) {
        MixerPlanView *planView = [_planViews objectAtIndex:self.lastPlanIndex];
        MixerCircleView   *view = nil;
        
        int count = [[step objectForKey:@"count"] intValue];
        [planView setSteps:count];
        
        if ([[step objectForKey:@"direction"] intValue] == 1) {
            [planView setTopView:YES];
            view = _topCircleView;
            [planView setBackgroundImage:[UIImage imageNamed:planView.steps > 0 ?  @"MixerCricleDown" : @"MixerCricleDown2"]
                                forState:UIControlStateNormal];
        } else if ([[step objectForKey:@"direction"] intValue] == -1) {
            [planView setTopView:NO];
            view = _bottomCircleView;
            [planView setBackgroundImage:[UIImage imageNamed:planView.steps > 0 ? 
                                          @"MixerCricleUp2" : @"MixerCricleUp"] 
                                forState:UIControlStateNormal];
        }
        [planView setDirection:view == _topCircleView ? 1 : -1];
        int limit = (planView.steps > 0 ? planView.steps : planView.steps * -1);
        
        for (int i = 0; i < limit; i++) {
            if ([[step objectForKey:@"direction"] intValue] == 1) {
                [self topAction:(limit/planView.steps)];
            } else {
                [self bottomAction:(limit/planView.steps)];                
            }
            
            //[self setTransform:CGAffineTransformRotate(view.transform, CC_DEGREES_TO_RADIANS(90 * planView.direction * planView.steps)) toView:view];
        }
        [self animatateStep:planView fromView:view];
        self.lastPlanIndex++;
    }
}

#pragma mark - Rotation

- (void) topAction:(int)direction
{
    MixerViewNumbers numbers;
    
    if (direction < 0) {
        numbers.component00 = _topCircleView.numbers.component01;
        numbers.component01 = _topCircleView.numbers.component11;
        numbers.component10 = _topCircleView.numbers.component00;
        numbers.component11 = _topCircleView.numbers.component10;
        
        [_topCircleView setNumbers:numbers];
        numbers.component00 = _topPos.component01;
        numbers.component01 = _topPos.component11;
        numbers.component10 = _topPos.component00;
        numbers.component11 = _topPos.component10;
        _topPos = numbers;
    } else {
        numbers.component00 = _topCircleView.numbers.component10;
        numbers.component01 = _topCircleView.numbers.component00;
        numbers.component10 = _topCircleView.numbers.component11;
        numbers.component11 = _topCircleView.numbers.component01;
        [_topCircleView setNumbers:numbers];
        
        numbers.component00 = _topPos.component10;
        numbers.component01 = _topPos.component00;
        numbers.component10 = _topPos.component11;
        numbers.component11 = _topPos.component01;
        _topPos = numbers;
    }
    numbers = [_bottomCircleView numbers];
    numbers.component00 = _topCircleView.numbers.component10;
    numbers.component01 = _topCircleView.numbers.component11;
    [_bottomCircleView setNumbers:numbers];
    
    numbers = _bottomPos;
    numbers.component00 = _topPos.component10;
    numbers.component01 = _topPos.component11;
    _bottomPos = numbers;
    
   // NSLog(@"%i, %i", _topPos.component00, _topPos.component01);
  //  NSLog(@"%i, %i", _topPos.component10, _topPos.component11);
  //  NSLog(@"%i, %i", _bottomPos.component10, _bottomPos.component11);
  //  NSLog(@"------");
    
    _leftComponent.component0 = [_topCircleView numbers].component00;
    _leftComponent.component1 = [_topCircleView numbers].component10;
    _leftComponent.component2 = [_bottomCircleView numbers].component10;
    
    _rigtComponent.component0 = [_topCircleView numbers].component01;
    _rigtComponent.component1 = [_topCircleView numbers].component11;
    _rigtComponent.component2 = [_bottomCircleView numbers].component11;
}

- (void) topTapGesture:(UITapGestureRecognizer *)sender
{
    [self bringSubviewToFront:_topCircleView];
    [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
    [_bottomCircleView.background setImage:[UIImage imageNamed:@"kolo_bg"]];
}

- (void) topGesture:(UIRotationGestureRecognizer *)sender
{
    if (_lastPlanIndex == kMixerPlanMaxNumber) {
        if ([self.subviews indexOfObject:_topCircleView] < [self.subviews indexOfObject:_bottomCircleView])
            return;
    }
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
        
        numbers.component00 = _bottomPos.component01;
        numbers.component01 = _bottomPos.component11;
        numbers.component10 = _bottomPos.component00;
        numbers.component11 = _bottomPos.component10;
        _bottomPos = numbers;
    } else {
        numbers.component00 = _bottomCircleView.numbers.component10;
        numbers.component01 = _bottomCircleView.numbers.component00;
        numbers.component10 = _bottomCircleView.numbers.component11;
        numbers.component11 = _bottomCircleView.numbers.component01;
        [_bottomCircleView setNumbers:numbers];
        
        numbers.component00 = _bottomPos.component10;
        numbers.component01 = _bottomPos.component00;
        numbers.component10 = _bottomPos.component11;
        numbers.component11 = _bottomPos.component01;
        _bottomPos = numbers;
    }
    numbers = [_topCircleView numbers];
    numbers.component10 = _bottomCircleView.numbers.component00;
    numbers.component11 = _bottomCircleView.numbers.component01;
    [_topCircleView setNumbers:numbers];
    
    numbers = _topPos;
    numbers.component10 = _bottomPos.component00;
    numbers.component11 = _bottomPos.component01;
    _topPos = numbers;
    
    _leftComponent.component0 = [_topCircleView numbers].component00;
    _leftComponent.component1 = [_topCircleView numbers].component10;
    _leftComponent.component2 = [_bottomCircleView numbers].component10;
    
    _rigtComponent.component0 = [_topCircleView numbers].component01;
    _rigtComponent.component1 = [_topCircleView numbers].component11;
    _rigtComponent.component2 = [_bottomCircleView numbers].component11;
}

- (void) bottomTapGesture:(UITapGestureRecognizer *)sender
{
    [self bringSubviewToFront:_bottomCircleView];
    [_topCircleView.background setImage:[UIImage imageNamed:@"kolo_bg"]];
    [_bottomCircleView.background setImage:[UIImage imageNamed:@"kolo_fg"]];
}

- (void) bottomGesture:(UIRotationGestureRecognizer *)sender
{
    if (_lastPlanIndex == kMixerPlanMaxNumber) {
        if ([self.subviews indexOfObject:_bottomCircleView] < [self.subviews indexOfObject:_topCircleView])
            return;
    }
    [self handleRotationWithView:_bottomCircleView gesture:sender];
}

- (void) animatateStep:(MixerPlanView *)step fromView:(UIView *)view
{
    if ([step steps] != 0)
        return;
    [step setAlpha:0.0];
    CGRect origFrame = [step frame];
    CGRect frame = origFrame;
    frame.size = CGSizeMake(frame.size.width * 8, frame.size.height * 8);
    CGRect viewFrame = [view frame];
    frame.origin = CGPointMake(512.0 - floorf(frame.size.width / 2),
                               CGRectGetMidY(viewFrame) - floorf(frame.size.width / 2));
    [step setFrame:frame];
    
    [UIView animateWithDuration:0.65 delay:0.0 options:UIViewAnimationCurveEaseInOut
                     animations:^(void) {
                         [step setAlpha:1];
                         [step setFrame:origFrame];
                     }
                     completion:NULL];
}

- (void) handleRotationWithView:(MixerCircleView *)view gesture:(UIRotationGestureRecognizer *)gesture
{
    __block int degress = CC_RADIANS_TO_DEGREES([gesture rotation]);
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        // save start rotation
        _changed = NO;
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
        if (!_changed)
            return;
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
        float radians = atan2(self.rotationTransform.b, self.rotationTransform.a);
        if ((degress < 45 && degress > 0) || (degress > -45 && degress < 0) || [gesture rotation] == radians) {
            // reset back
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut
                             animations:^(void) {
                                 [self setTransform:self.rotationTransform toView:view];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            if (_lastPlanIndex == kMixerPlanMaxNumber) {
                [self setTransform:self.rotationTransform toView:view];
                return;
            }
            // move to next/prev
            __block int direction = ([gesture rotation] > 0 ? 1 : -1);
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseIn
                             animations:^(void) {
                                 degress = degress % 360;
                                 //NSLog(@"finish %i", degress);
                                 CGAffineTransform transform = CGAffineTransformRotate(self.rotationTransform, 
                                                                                       CC_DEGREES_TO_RADIANS(roundf((float)degress / 90) * 90));
                                 [self setTransform:transform toView:view];
                             }
                             completion:^(BOOL finished) {
                                 MixerPlanView *planView = [_planViews objectAtIndex:_lastPlanIndex];
                                 [self setSteps:roundf((float)degress / 90)];
                                 //NSLog(@"steps: %i", self.steps);
                                 
                                 if (_lastPlanIndex > 0 && (([[_planViews objectAtIndex:_lastPlanIndex - 1] topView] && view == _topCircleView) 
                                                            || (![[_planViews objectAtIndex:_lastPlanIndex - 1] topView] && view == _bottomCircleView))) {
                                     planView = [_planViews objectAtIndex:_lastPlanIndex - 1];
                                 } else if (_lastPlanIndex < kMixerPlanMaxNumber) {
                                     [planView setSteps:0];
                                     [self animatateStep:planView fromView:view];
                                     _lastPlanIndex++;
                                 }
                                 int limit = (self.steps > 0 ? self.steps : self.steps * -1);
                                 [planView setDirection:view == _topCircleView ? 1 : -1];
                                 
                                 if (view == _topCircleView) {
                                     for (int i = 0; i < limit; i++) {
                                         [self topAction:direction];
                                     }
                                     [planView setSteps:planView.steps + self.steps];
                                     if ([planView steps] > 4) 
                                         [planView setSteps:4];
                                     else if ([planView steps] < -4)
                                         [planView setSteps:-4];
                                     [planView setBackgroundImage:[UIImage imageNamed:planView.steps > 0 ? 
                                                                   @"MixerCricleDown" : @"MixerCricleDown2"]
                                                          forState:UIControlStateNormal];
                                     [planView setTopView:YES];
                                     
                                     if ([planView steps] == 0) {
                                         [UIView animateWithDuration:0.2 animations:^(void) {
                                             [planView setAlpha:0.0];
                                         }];
                                         _lastPlanIndex--;
                                     }
                                 } else {
                                     for (int i = 0; i < limit; i++) {
                                         [self bottomAction:direction];
                                     }
                                     [planView setSteps:planView.steps + self.steps];
                                     if ([planView steps] > 4) 
                                         [planView setSteps:4];
                                     else if ([planView steps] < -4)
                                         [planView setSteps:-4];
                                     [planView setBackgroundImage:[UIImage imageNamed:planView.steps > 0 ? 
                                                                    @"MixerCricleUp2" : @"MixerCricleUp"] 
                                                          forState:UIControlStateNormal];
                                     [planView setTopView:NO];
                                     
                                     if ([planView steps] == 0) {
                                         [UIView animateWithDuration:0.2 animations:^(void) {
                                             [planView setAlpha:0.0];
                                         }];
                                         _lastPlanIndex--;
                                     }
                                 }
                             }];
            [gesture setEnabled:YES];
        }
    } else {
        _changed = YES;
        CGAffineTransform transform = CGAffineTransformRotate(self.rotationTransform, [gesture rotation]);
        [self setTransform:transform toView:view];
    }
}

- (void) setTransform:(CGAffineTransform)transform toView:(MixerCircleView *)view
{
    [view.background setTransform:transform];
    float radians1 = atan2(transform.b, transform.a);
    float radians2 = atan2(self.rotationTransform.b, self.rotationTransform.a);
    //NSLog(@"%.4f vs %.4f", radians1, radians2);
    
    for (int i = 1; i < 5; i++) {
        [[view viewWithTag:i] setTransform:CGAffineTransformMakeRotation(radians1 -radians2)];
    }
}

@end