//
//  MixerCircleView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerView.h"
#import "MixerCircleView.h"


@interface MixerView ()

@end

@implementation MixerView

@synthesize leftComponent = _leftComponent;
@synthesize rigtComponent = _rigtComponent;

@synthesize topCircleView = _topCircleView;
@synthesize bottomCircleView = _bottomCircleView;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rigtComponent
{
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 150.0, 250.0)];
    
    if (self) {
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
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _topCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, 30.0, 150.0, 150.0)];
        [_topCircleView.layer setCornerRadius:20.0];
        [_topCircleView.layer setBorderWidth:1];
        [_topCircleView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [_topCircleView setBackgroundColor:[UIColor redColor]];
        [_topCircleView addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topCircleView];
        
        _bottomCircleView = [[MixerCircleView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_topCircleView.frame) - 70.0, 150.0, 150.0)];
        [_bottomCircleView.layer setCornerRadius:20.0];
        [_bottomCircleView.layer setBorderWidth:1];
        [_bottomCircleView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [_bottomCircleView setBackgroundColor:[UIColor redColor]];
        [_bottomCircleView addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_bottomCircleView belowSubview:_topCircleView];
    }
    return self;
}
        
#pragma mark -

- (void) topAction:(id)sender
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         MixerViewNumbers numbers;
                         numbers.component00 = _topCircleView.numbers.component01;
                         numbers.component01 = _topCircleView.numbers.component11;
                         numbers.component10 = _topCircleView.numbers.component00;
                         numbers.component11 = _topCircleView.numbers.component10;
                         //CGAffineTransform transform = CGAffineTransformRotate([_topCircleView transform], CC_DEGREES_TO_RADIANS(90));
                         //[_topCircleView setTransform:transform];
                         [_topCircleView setNumbers:numbers];
                         
                         numbers = [_bottomCircleView numbers];
                         numbers.component00 = _topCircleView.numbers.component10;
                         numbers.component01 = _topCircleView.numbers.component11;
                         [_bottomCircleView setNumbers:numbers];
                     }
                     completion:NULL];
}

- (void) bottomAction:(id)sender
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         MixerViewNumbers numbers;
                         numbers.component00 = _bottomCircleView.numbers.component01;
                         numbers.component01 = _bottomCircleView.numbers.component11;
                         numbers.component10 = _bottomCircleView.numbers.component00;
                         numbers.component11 = _bottomCircleView.numbers.component10;
                         //CGAffineTransform transform = CGAffineTransformRotate([_bottomCircleView transform], CC_DEGREES_TO_RADIANS(90));
                         //[_bottomCircleView setTransform:transform];
                         [_bottomCircleView setNumbers:numbers];
                         
                         numbers = [_topCircleView numbers];
                         numbers.component10 = _bottomCircleView.numbers.component00;
                         numbers.component11 = _bottomCircleView.numbers.component01;
                         [_topCircleView setNumbers:numbers];                     
                     }
                     completion:NULL];
}

@end
