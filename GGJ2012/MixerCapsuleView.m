//
//  MixerCapsuleView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerCapsuleView.h"


@interface MixerCapsuleView ()

- (NSString *) _stringForComponent:(int)component;

@end

@implementation MixerCapsuleView

@synthesize capsule = _capsule;
@synthesize enabled = _enabled;
@synthesize delegate = _delegate;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    if (self) {
        [self.layer setCornerRadius:20.0];
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        for (int i = 0; i < 3; i++) {
            UIButton *componentView = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 10 + i * 55, 50.0, 50.0)];
            [componentView setBackgroundColor:[UIColor blueColor]];
            [componentView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [componentView.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [componentView.titleLabel setTextAlignment:UITextAlignmentCenter];
            [componentView addTarget:self action:@selector(componentAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:componentView];
        }
    }
    return self;
}

#pragma mark -

- (void) setEnabled:(BOOL)enabled
{
    [self setUserInteractionEnabled:enabled];
}

- (void) setCapsule:(CapsuleComponents)capsule
{
    _capsule = capsule;
    
    for (int i = 0; i < 3; i++) {
        UIButton *componentView = [self.subviews objectAtIndex:i];
        NSString *text = @"";
        if (i == 0) {
            text = [self _stringForComponent:capsule.component0];
        } else if (i == 1) {
            text = [self _stringForComponent:capsule.component1];
        } else if (i == 2) {
            text = [self _stringForComponent:capsule.component2];
        }
        [componentView setTitle:text forState:UIControlStateNormal];
    }
}

- (void) componentAction:(UIButton *)button
{
    NSInteger index = [self.subviews indexOfObject:button];
    int componnet = 0;
    if (index == 0) {
        componnet = _capsule.component0 + 1;
        if (componnet > 3)
            componnet = 0;
        _capsule.component0 = componnet;
    } else if (index == 1) {
        componnet = _capsule.component1 + 1;
        if (componnet > 3)
            componnet = 0;
        _capsule.component1 = componnet;
    } else if (index == 2) {
        componnet = _capsule.component2 + 1;
        if (componnet > 3)
            componnet = 0;
        _capsule.component2 = componnet;
    }
    [button setTitle:[self _stringForComponent:componnet] forState:UIControlStateNormal];
    [_delegate view:self didSetCapsule:_capsule];
}

- (NSString *) _stringForComponent:(int)component
{
    switch (component) {
        case 0:
            return @"A";
            break;
        case 1:
            return @"B";
            break;
        case 2:
            return @"C";
            break;
        case 3:
            return @"D";
            break;
        case 4:
            return @"E";
            break;
        case 5:
        default:
            return @"F";
            break;
    }
}

@end
