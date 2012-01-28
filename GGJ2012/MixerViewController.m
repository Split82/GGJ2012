//
//  MixazniPultViewController.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerViewController.h"
#import "MixerView.h"
#import "MixerCapsuleView.h"
#import "MixerCircleView.h"
#import "HorizontalPickerView.h"


@interface MixerViewController () <MixerCapsuleViewDelegate>

@property (nonatomic, strong) MixerView *mixerView;

@property (nonatomic, assign) CapsuleComponents leftResultCapsule;
@property (nonatomic, assign) CapsuleComponents rightResultCapsule;

@end

@implementation MixerViewController

@synthesize mixerView = _mixerView;

@synthesize leftResultCapsule = _leftResultCapsule;
@synthesize rightResultCapsule = _rightResultCapsule;

@synthesize delegate = _delegate;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rightComponent
{
    self = [super initWithFrame:CGRectMake(0, 0, 500, 550)];
    
    if (self) {
        _leftResultCapsule = leftComponent;
        _rightResultCapsule = rightComponent;
        
        UIButton *button;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button.layer setCornerRadius:4];
        [button sizeToFit];
        [button setFrame:CGRectOffset(button.frame, 5.0, 5.0)];
        [button addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Reset" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button.layer setCornerRadius:4];
        [button sizeToFit];
        [button setFrame:CGRectOffset(button.frame, 500 - button.frame.size.width - 5.0, 5.0)];
        [button addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self setBackgroundColor:[UIColor grayColor]];
        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
        [self.layer setShadowRadius:5];
        [self.layer setShadowOpacity:0.4];
        [self.layer setCornerRadius:5];
        
        _mixerView = [[MixerView alloc] initWithLeftComponent:leftComponent rightComponent:rightComponent];
        [_mixerView setTag:99];
        CGRect frame = [_mixerView frame];
        frame.origin.x = floorf((self.bounds.size.width - frame.size.width) / 2), 
        frame.origin.y = 10.0;
        [_mixerView setFrame:frame];
        [self addSubview:_mixerView];
        
        MixerCapsuleView *capsule = nil;
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(10.0, frame.origin.y + 160.0, 70.0, 180.0)];
        [capsule setTag:100];
        [capsule setBackgroundColor:[UIColor redColor]];
        [capsule setCapsule:leftComponent];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
        
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(500 - 80.0, frame.origin.y + 160.0, 70.0, 180.0)];
        [capsule setTag:101];
        [capsule setBackgroundColor:[UIColor redColor]];
        [capsule setCapsule:rightComponent];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
    }
    return self;
}

#pragma mark -

- (void) resetAction:(id)sender
{
    [_mixerView reset];
}

- (void) closeAction:(id)sender
{
    [self removeFromSuperview];
}

- (void) doneAction:(id)sender
{
    [_delegate viewController:self leftCapsule:_leftResultCapsule rightCapsule:_rightResultCapsule];
    [self removeFromSuperview];
}

#pragma mark Capsule delegate

- (void) view:(MixerCapsuleView *)view didSetCapsule:(CapsuleComponents)capsule
{
    MixerView *mixerView = (MixerView *)[self viewWithTag:99];
    
    if ([view tag] == 100) {
        [mixerView setLeftComponent:capsule rightComponent:mixerView.rigtComponent];
    } else if ([view tag] == 101) {
        [mixerView setLeftComponent:mixerView.leftComponent rightComponent:capsule];
    }
}

@end
