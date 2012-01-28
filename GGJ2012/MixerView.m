//
//  MixerCircleView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerView.h"
#import "MixerCircleView.h"


#define kMixerPlanMaxNumber     6


@interface MixerView ()

- (void) handleRotationWithView:(MixerCircleView *)view gesture:(UIRotationGestureRecognizer *)gesture;
@property (nonatomic, assign) CGAffineTransform rotationTransform;

- (void) topTapGesture:(UITapGestureRecognizer *)sender;
- (void) topAction:(int)direction;

- (void) bottomTapGesture:(UITapGestureRecognizer *)sender;
- (void) bottomAction:(int)direction;

@property (nonatomic, strong) NSMutableArray *planViews;
@property (nonatomic, assign) NSInteger lastPlanIndex;

@end

@implementation MixerView

@synthesize leftComponent = _leftComponent;
@synthesize rigtComponent = _rigtComponent;
@synthesize rotationTransform = _rotationTransform;

@synthesize topCircleView = _topCircleView;
@synthesize bottomCircleView = _bottomCircleView;

@synthesize planViews = _planViews;
@synthesize lastPlanIndex = _lastPlanIndex;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent
{
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 300.0, 300 + 150.0)];
    
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
        UITapGestureRecognizer *tapGesture = nil;
        
        _topCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 300.0)];
        [_topCircleView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_topCircleView];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTapGesture:)];
        [tapGesture setNumberOfTapsRequired:1];
        [_topCircleView addGestureRecognizer:tapGesture];
        
        rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(topGesture:)];
        [rotationGesture requireGestureRecognizerToFail:tapGesture];
        [_topCircleView addGestureRecognizer:rotationGesture];
        
        _bottomCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_topCircleView.frame) - 150.0, 300.0, 300.0)];
        [_bottomCircleView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_bottomCircleView belowSubview:_topCircleView];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomTapGesture:)];
        [tapGesture setNumberOfTapsRequired:1];
        [_bottomCircleView addGestureRecognizer:tapGesture];
        
        rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
        [rotationGesture requireGestureRecognizerToFail:tapGesture];
        [_bottomCircleView addGestureRecognizer:rotationGesture];
        
        CGFloat originX = floorf((frame.size.width - 70 * kMixerPlanMaxNumber) / 2);
        _planViews = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < kMixerPlanMaxNumber; i++) {
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(originX + i * 70.0, CGRectGetMaxY(_bottomCircleView.frame) + 10.0, 
                                                                              70.0, 70.0)];
            [view setImage:[UIImage imageNamed:@"MixerCricleEmpty"]];
            [view setBackgroundColor:[UIColor clearColor]];
            [self addSubview:view];
            [_planViews addObject:view];
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
    [_topCircleView setMode:MixerCircleViewModesFull];
    
    MixerViewNumbers numbers1;
    numbers1.component00 = _leftComponent.component1;
    numbers1.component01 = _rigtComponent.component1;
    numbers1.component10 = _leftComponent.component2;
    numbers1.component11 = _rigtComponent.component2;
    
    [_bottomCircleView setNumbers:numbers1];
    [_bottomCircleView setMode:MixerCircleViewModesFull];
}

- (void) topAction:(int)direction
{
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
}

- (void) topTapGesture:(UITapGestureRecognizer *)sender
{
    [self bringSubviewToFront:_topCircleView];
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
}

- (void) bottomGesture:(UIRotationGestureRecognizer *)sender
{
    [self handleRotationWithView:_bottomCircleView gesture:sender];
}

- (void) handleRotationWithView:(MixerCircleView *)view gesture:(UIRotationGestureRecognizer *)gesture
{
    int degress = CC_RADIANS_TO_DEGREES([gesture rotation]);
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        // save start rotation
        [self setRotationTransform:view.background.transform];
        [self bringSubviewToFront:view];
    } else if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
        if ((degress < 45 && degress > 0) || (degress > -45 && degress < 0)) {
            // reset back
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut
                             animations:^(void) {
                                 [view.background setTransform:self.rotationTransform];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            // move to next/prev
            __block int direction = ([gesture rotation] > 0 ? 1 : -1);
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseIn
                             animations:^(void) {
                                 CGAffineTransform transform = CGAffineTransformRotate(self.rotationTransform, 
                                                                                       CC_DEGREES_TO_RADIANS(90 * direction));
                                 [view.background setTransform:transform];
                             }
                             completion:^(BOOL finished) {
                                 UIImageView *imageView = [_planViews objectAtIndex:_lastPlanIndex];
                                 
                                 if (view == _topCircleView) {
                                     [self topAction:direction];
                                     [imageView setImage:[UIImage imageNamed:direction == 1 ? @"MixerCricleDown" : @"MixerCricleDown2"]];
                                 } else {
                                     [self bottomAction:direction];
                                     [imageView setImage:[UIImage imageNamed:direction == 1 ? @"MixerCricleUp2" : @"MixerCricleUp"]];
                                 }
                                 if (_lastPlanIndex + 1 < kMixerPlanMaxNumber)
                                     _lastPlanIndex++;
                             }];
            [gesture setEnabled:YES];
        }
    } else {
        if (degress >= 90 || degress <= -90) {
            // when it's more then 90 stop
            [gesture setEnabled:NO];
        } else { 
            CGAffineTransform transform = CGAffineTransformRotate(self.rotationTransform, [gesture rotation]);
            [view.background setTransform:transform];
        }        
    }
}

@end
