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


@interface MixerViewController () <MixerCapsuleViewDelegate>

@property (nonatomic, assign) CapsuleComponents leftResultCapsule;
@property (nonatomic, assign) CapsuleComponents rightResultCapsule;

@end

@implementation MixerViewController

@synthesize leftResultCapsule = _leftResultCapsule;
@synthesize rightResultCapsule = _rightResultCapsule;

@synthesize delegate = _delegate;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rightComponent
{
    self = [super initWithFrame:CGRectMake(0, 0, 500, 550)];
    
    if (self) {
        _leftResultCapsule = leftComponent;
        _rightResultCapsule = rightComponent;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button setFrame:CGRectOffset(button.frame, 500 - button.frame.size.width, 0.0)];
        [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self setBackgroundColor:[UIColor greenColor]];
        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
        [self.layer setShadowRadius:5];
        [self.layer setShadowOpacity:0.4];
        [self.layer setCornerRadius:5];
        
        MixerView *mixerView = [[MixerView alloc] initWithLeftComponent:leftComponent rightComponent:rightComponent];
        [mixerView setTag:99];
        CGRect frame = [mixerView frame];
        frame.origin.x = floorf((self.bounds.size.width - frame.size.width) / 2), 
        frame.origin.y = floorf((self.bounds.size.height - frame.size.height) / 2) + 40.0;
        [mixerView setFrame:frame];
        [self addSubview:mixerView];
        
        MixerCapsuleView *capsule = nil;
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(frame.origin.x, 10.0, 70.0, 180.0)];
        [capsule setTag:100];
        [capsule setBackgroundColor:[UIColor redColor]];
        [capsule setCapsule:leftComponent];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
        
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(frame.origin.x + 80.0, 10.0, 70.0, 180.0)];
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
