//
//  MixazniPultViewController.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 27.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixazniPultViewController.h"


@interface MixazniPultViewController ()

@property (nonatomic, assign) CapsuleComponents leftResultCapsule;
@property (nonatomic, assign) CapsuleComponents rightResultCapsule;

@end

@implementation MixazniPultViewController

@synthesize leftCapsule = _leftCapsule;
@synthesize rightCapsule = _rightCapsule;

@synthesize leftResultCapsule = _leftResultCapsule;
@synthesize rightResultCapsule = _rightResultCapsule;

@synthesize delegate = _delegate;

- (id) init
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 500.0, 26.0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:@"Text Label"];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:label];
        
        
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
    [_delegate viewController:self leftCapsule:_leftResultCapsule rightCapsule:_rightCapsule];
    [self removeFromSuperview];
}

@end
