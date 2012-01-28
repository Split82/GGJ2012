//
//  MixerPlanView.m
//  GGJ2012
//
//  Created by Lukáš Foldýna on 28.01.12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import "MixerPlanView.h"


@implementation MixerPlanView

@synthesize steps = _steps;
@synthesize topView = _topView;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    if (self) {
        _steps = 0;
        [self.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    return self;
}

- (void) setSteps:(NSInteger)steps
{
    _steps = steps;

    if (_steps == 0) {
        [self setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self setTitle:[NSString stringWithFormat:@"%i", (_steps < 0 ? _steps * -1 : _steps)] forState:UIControlStateNormal];
    }
}

@end
