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
@synthesize result = _result;
@synthesize delegate = _delegate;

- (id) initWithResult:(MixerResult *)result
{
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, 710)];
    
    if (self) {
        _result = result;
        
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
        
        _mixerView = [[MixerView alloc] initWithLeftComponent:result.leftInput rightComponent:result.rightInput];
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
        [capsule setCapsule:result.leftInput];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
        
        capsule = [[MixerCapsuleView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 246.0, frame.origin.y + 130.0, 70.0, 350.0)];
        [capsule setTag:101];
        [capsule setCapsule:result.rightInput];
        [capsule setDelegate:self];
        [capsule setEnabled:YES];
        [self addSubview:capsule];
        
        for (UIView *view in [_mixerView planViews]) {
            [self addSubview:view];
        }
        [_mixerView setAllSteps:_result.steps];
    }
    return self;
}

#pragma mark -

- (void) resetAction:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
    
    MixerCapsuleView *capsule1 = (id)[self viewWithTag:100];
    MixerCapsuleView *capsule2 = (id)[self viewWithTag:101];
    [_mixerView setLeftComponent:capsule1.capsule rightComponent:capsule2.capsule];
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
    MixerCapsuleView *capsule1 = (id)[self viewWithTag:100];
    MixerCapsuleView *capsule2 = (id)[self viewWithTag:101];
    
    MixerResult *result = [[MixerResult alloc] init];
    [result setLeftInput:capsule1.capsule];
    [result setRightInput:capsule2.capsule];
    [result setSteps:[_mixerView allSteps]];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        if (i == 0) {
            [array addObject:[NSNumber numberWithInt:_mixerView.topPos.component00]];
        } else if (i == 1) {
            [array addObject:[NSNumber numberWithInt:_mixerView.topPos.component10]];
        } else if (i == 2) {
            [array addObject:[NSNumber numberWithInt:_mixerView.bottomPos.component10]];
        } else if (i == 3) {
             [array addObject:[NSNumber numberWithInt:_mixerView.topPos.component01]];
        } else if (i == 4) {
            [array addObject:[NSNumber numberWithInt:_mixerView.topPos.component11]];
        } else if (i == 5) {
            [array addObject:[NSNumber numberWithInt:_mixerView.bottomPos.component11]];
        }
    }
    [result setPositions:array];
    
    [_delegate viewController:self result:result];
    [self closeAction:nil];
}

#pragma mark Capsule delegate

- (int) valueForIndex:(int)index set:(CapsuleComponents)capsule
{
    if (index == 0) {
        return capsule.component0;
    } else if (index == 1) {
        return capsule.component1;
    } else {
        return capsule.component2;
    }
}

- (void) setValueAtIndex:(NSInteger)index value:(int)value top:(MixerViewNumbers)top bottom:(MixerViewNumbers)bottom
{
    CapsuleComponents result;
    
    if (top.component00 == index) {
        result = [_mixerView leftComponent];
        result.component0 = value;
        [_mixerView setLeftComponent:result];
    } else if (top.component01 == index) {
        result = [_mixerView rigtComponent];
        result.component0 = value;
        [_mixerView setRigtComponent:result];
    } else if (top.component10 == index) {
        result = [_mixerView leftComponent];
        result.component1 = value;
        [_mixerView setLeftComponent:result];
    } else if (top.component11 == index) {
        result = [_mixerView rigtComponent];
        result.component1 = value;
        [_mixerView setRigtComponent:result];
    } else if (bottom.component10 == index) {
        result = [_mixerView leftComponent];
        result.component2 = value;
        [_mixerView setLeftComponent:result];
    } else if (bottom.component11 == index) {
        result = [_mixerView rigtComponent];
        result.component2 = value;
        [_mixerView setRigtComponent:result];
    }
}

- (void) view:(MixerCapsuleView *)view didSetCapsule:(CapsuleComponents)capsule index:(NSInteger)index
{
    if ([view tag] == 100) {
        [self setValueAtIndex:index value:[self valueForIndex:index set:view.capsule]
                          top:_mixerView.topPos bottom:_mixerView.bottomPos];
    } else if ([view tag] == 101) {
        [self setValueAtIndex:index + 3 value:[self valueForIndex:index set:view.capsule]
                          top:_mixerView.topPos bottom:_mixerView.bottomPos];
    }
}

@end
