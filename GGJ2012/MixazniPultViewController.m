//
//  MixazniPultViewController.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixazniPultViewController.h"
#import "MixerView.h"
#import "MixerCircleView.h"


@interface MixazniPultViewController ()

@property (nonatomic, assign) CapsuleComponents leftResultCapsule;
@property (nonatomic, assign) CapsuleComponents rightResultCapsule;

@end

@implementation MixazniPultViewController

@synthesize leftResultCapsule = _leftResultCapsule;
@synthesize rightResultCapsule = _rightResultCapsule;

@synthesize delegate = _delegate;

- (id) initWithLeftComponent:(CapsuleComponents)leftComponent rightComponent:(CapsuleComponents)rightComponent
{
    self = [super initWithFrame:CGRectMake(0, 0, 500, 500)];
    
    if (self) {
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
        CGRect frame = [mixerView frame];
        frame.origin.x = floorf((self.bounds.size.width - frame.size.width) / 2), 
        frame.origin.y = floorf((self.bounds.size.height - frame.size.height) / 2);
        [mixerView setFrame:frame];
        [self addSubview:mixerView];
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

@end
