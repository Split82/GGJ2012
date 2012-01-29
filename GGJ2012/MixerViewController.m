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

@end

@implementation MixerViewController

@synthesize mixerView = _mixerView;

@synthesize delegate = _delegate;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rightComponent
{
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, 710)];
    
    if (self) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fg"]];
        [backgroundView setFrame:CGRectMake(7.0, -30.0, self.bounds.size.width, [[UIScreen mainScreen] bounds].size.width)];
        [backgroundView setContentMode:UIViewContentModeCenter];
        [self addSubview:backgroundView];
        
        UIButton *button;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button setFrame:CGRectOffset(button.frame, self.bounds.size.width - 127.0, 640.0)];
        [button addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button setFrame:CGRectOffset(button.frame, 0.0, 640.0)];
        [button addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _mixerView = [[MixerView alloc] initWithLeftComponent:leftComponent rightComponent:rightComponent];
        [_mixerView setTag:99];
        CGRect frame = [_mixerView frame];
        frame.origin.x = floorf((self.bounds.size.width - frame.size.width) / 2) + 5.0; 
        frame.origin.y = 5.0;
        [_mixerView setFrame:frame];
        [self addSubview:_mixerView];
        
        [self bringSubviewToFront:backgroundView];
        
        MixerCapsuleView *capsule = nil;
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(207.0, frame.origin.y + 130.0, 70.0, 350.0)];
        [capsule setTag:100];
        [capsule setCapsule:leftComponent];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
        
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 246.0, frame.origin.y + 130.0, 70.0, 350.0)];
        [capsule setTag:101];
        [capsule setCapsule:rightComponent];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
        
        for (UIView *view in [_mixerView planViews]) {
            [self addSubview:view];
        }
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
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         [[self superview] setBackgroundColor:[UIColor clearColor]];
                         CGRect frame = [self frame];
                         frame.origin.y = self.bounds.size.height;
                         [self setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         [[self superview] removeFromSuperview];
                     }];
}

- (void) doneAction:(id)sender
{
    MixerView *mixerView = (MixerView *)[self viewWithTag:99];
    [_delegate viewController:self leftCapsule:mixerView.leftComponent rightCapsule:mixerView.rigtComponent];
    [self closeAction:nil];
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
